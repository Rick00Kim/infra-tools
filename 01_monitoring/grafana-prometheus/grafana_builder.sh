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

# Prompt user to insert inputs
echo 'Do you wanna install Grafana and Promethus on this Machine?'
echo '(If you don''t any input, it will be exit)'
read -p 'Are you sure?[y/n] - ' confirm_flg

# Confirm to user
if [ -z $confirm_flg ] || [ $confirm_flg != "y" ]; then
  echo "User cancelled or wrong answer..."
  exit 1
fi

# Execute Main process
# Input
promethus_port=$(get_port "PROMETHUS" 9090)
promethus_container_name=$(get_require_data "PROMETHUS container name" "false")
grafana_port=$(get_port "GRAFANA" 3000)
grafana_container_name=$(get_require_data "GRAFANA container name" "false")

# Check input information
check_input \
  "$promethus_port" \
  "$promethus_container_name" \
  "$grafana_port" \
  "$grafana_container_name"

# When exists wrong input, exit program
if [ $? == 1 ]; then
  echo "There is wrong input..."
  exit 1
fi

# Show all input
echo
echo "Let we build sensu go with your input below."
echo "------------ Input Check -----------------"
echo "PROMETHUS port: "$promethus_port
echo "PROMETHUS container name: "$promethus_container_name
echo "GRAFANA port: "$grafana_port
echo "GRAFANA container name: "$grafana_container_name
echo "------------------------------------------"
read -p 'Are you sure?[y/n] - ' confirm_build
echo

# Confirm to user
if [ -z $confirm_build ] || [ $confirm_build != "y" ]; then
  echo "User cancelled or wrong answer..."
  exit 1
else
  docker run -d -p ${promethus_port}:9090 \
    -v `pwd`/prometheus.yml:/etc/prometheus/prometheus.yml \
    --name ${promethus_container_name} \
    prom/prometheus
  echo "Created promethus container ($promethus_container_name) -> port is $promethus_port"

  docker run -d -p ${grafana_port}:3000 \
    --name=${grafana_container_name} \
    grafana/grafana
  echo "Created grafana container ($grafana_container_name) -> port is $grafana_port"
fi
