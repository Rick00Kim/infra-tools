#!/bin/bash

# Import Common script
. common.sh

# Start [Check arguments]
while getopts ":h" option  
do
  case $option inㄹ
    h)
      Help
      exit;;
  esac
done

# Check before
PROMETHUS_YAML="prometheus.yml"
if [ ! -f "$PROMETHUS_YAML" ]; then
    echo "$PROMETHUS_YAML not exists."
    echo "Please create a $PROMETHUS_YAML using the template file."
    echo "  (Template file name: template_promethus.yml)"
    exit 1
fi

# Prompt user to insert inputs
echo 'Do you wanna install Grafana and Promethus on this Machine?'
echo '   (If you don''t any input, it will be exit)'
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
  # Run Promethus container
  docker run -d -p ${promethus_port}:9090 \
    -v `pwd`/$PROMETHUS_YAML:/etc/prometheus/$PROMETHUS_YAML \
    --name ${promethus_container_name} \
    prom/prometheus
  echo "Created promethus container ($promethus_container_name) -> port is $promethus_port"

  # Run Grafana container
  docker run -d -p ${grafana_port}:3000 \
    --name ${grafana_container_name} \
    grafana/grafana
  echo "Created grafana container ($grafana_container_name) -> port is $grafana_port"

  # Create network and connect created containers
  network_name=$(uname -n)-monitoring
  docker network create -d bridge ${network_name}
  docker network connect ${network_name} ${promethus_container_name}
  docker network connect ${network_name} ${grafana_container_name}
  echo "Created docker network ${network_name} and connected below."
  echo "Conatainer -> ${promethus_container_name}"
  echo "Conatainer -> ${grafana_container_name}"
fi

echo "Completed Building monitoring tool."
echo "Please run node export in Target VM what you want monitor."
echo "example) docker run -d -p {specific port}:9100 prom/node-exporter"
