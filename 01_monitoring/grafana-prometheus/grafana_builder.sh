#!/bin/bash

# Import Common script
. common.sh

# Start [Check arguments]
while getopts ":h" option  
do
  case $option in
    h)
      Help
      exit;;
  esac
done

# Prompt user to insert inputs [Sensu Kinds]
echo 'What is the purpose of using Sensu on this Machine?'
echo '(If you don''t any input, it will be set Slave)'
read -p '[Master or Slave]: ' kinds

# Check argument [Target variable: Sensu Kinds]
if [ -z $kinds ];then
  echo "It will make sensu agent..."
  # Confirm to user
  read -p 'Are you sure?[y/n] - ' default_kind_confirm
  if [ -z $default_kind_confirm ] || [ $default_kind_confirm != "y" ]; then
    exit 1
  else
    # Set default kinds
    kinds="Slave"
  fi
else
  if [[ ! "$kinds" =~ ^(Master|Slave)$ ]]; then
    echo "Wrong input kinds -> " $kinds
    exit 1
  fi
fi

# Execute Main process
case $kinds in
  Master)
    # Building Sensu go Process
    echo "It starts building sensu go (Master server)"
    # Input
    web_ui_port=$(get_port "SENSU WEB UI" 3000)
    api_port=$(get_port "SENSU API" 8080)
    agent_port=$(get_port "SENSU AGENT" 8081)
    admin_user_name=$(get_require_data "Admin Username" "false")
    admin_password=$(get_require_data "Admin Password" "true")

    # Check input information
    check_input \
      "$web_ui_port" \
      "$api_port" \
      "$agent_port" \
      "$admin_user_name" \
      "$admin_password"

    # When exists wrong input, exit program
    if [ $? == 1 ]; then
      echo "There is wrong input..."
      exit 1
    fi

    # Show all input
    echo
    echo "Let we build sensu go with your input below."
    echo "------------ Input Check -----------------"
    echo "SENSU WEB UI port: "$web_ui_port
    echo "SENSU API port: "$api_port
    echo "SENSU AGENT port: "$agent_port
    echo "Admin Username: "$admin_user_name
    echo "Admin Password: "$admin_password
    echo "------------------------------------------"
    read -p 'Are you sure?[y/n] - ' confirm_build
    echo

    # Confirm to user
    if [ -z $confirm_build ] || [ $confirm_build != "y" ]; then
      echo "User cancelled or wrong answer..."
      exit 1
    else
      docker run -v /var/lib/sensu:/var/lib/sensu -d \
          --name sensu-backend \
          -p $web_ui_port:3000 \
          -p $api_port:8080 \
          -p $agent_port:8081 \
          -e SENSU_BACKEND_CLUSTER_ADMIN_USERNAME="$admin_user_name" \
          -e SENSU_BACKEND_CLUSTER_ADMIN_PASSWORD="$admin_password" \
          sensu/sensu:latest \
          sensu-backend start --state-dir /var/lib/sensu/sensu-backend --log-level debug
      echo "Completed building Sensu go!"
      echo "ENJOY Sensu monitoring~"
    fi
    ;;
  Slave)
    # Building Sensu agent Process
    echo "It starts building sensu agent (Slave server)"
    # Input
    web_socket_url=$(get_require_data "WEB Socket URL" "false")
    name_space=$(get_require_data "SENSU namespace" "false")

    # Check input information
    check_input \
      "$web_socket_url" \
      "$name_space"

    # When exists wrong input, exit program
    if [ $? == 1 ]; then
      echo "There is wrong input..."
      exit 1
    fi

    # Show all input
    echo
    echo "Let we build sensu agent with your input below."
    echo "------------ Input Check -----------------"
    echo "WEB Socket URL: "$web_socket_url
    echo "SENSU namespace: "$name_space
    echo "------------------------------------------"
    read -p 'Are you sure?[y/n] - ' confirm_build
    echo

    # Confirm to user
    if [ -z $confirm_build ] || [ $confirm_build != "y" ]; then
      echo "User cancelled or wrong answer..."
      exit 1
    else
      docker run -v /var/lib/sensu:/var/lib/sensu -d \
        --name sensu-agent sensu/sensu sensu-agent start \
        --name $(uname -n) --namespace $name_space \
        --backend-url ws://$web_socket_url \
        --log-level debug --api-host 0.0.0.0 \
        --cache-dir /var/lib/sensu
      echo "Completed building Sensu agent!"
      echo "ENJOY Sensu monitoring~"
    fi
    ;;
  *)
    echo "A problem has occurred. Please execute script again..."
    exit 1
    ;;
esac
