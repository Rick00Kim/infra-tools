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

# Execute Main process
# Input
promethus_port=$(get_port "PROMETHUS UI" 9090)
container_name=$(get_require_data "PROMETHUS container name" "false")
api_port=$(get_port "SENSU API" 8080)
agent_port=$(get_port "SENSU AGENT" 8081)
admin_password=$(get_require_data "Admin Password" "true")

docker run -d -p ${promethus_port}:9090 \
  -v `pwd`/prometheus.yml:/etc/prometheus/prometheus.yml \
  --name ${container_name} \
  prom/prometheus

