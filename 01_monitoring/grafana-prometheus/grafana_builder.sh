#!/bin/bash

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

# Execute Main process
