#!/bin/bash

#######################################################
# Help                                                #
#######################################################
Help()
{
   # Display Help
   echo "You don't have to set any options."
   echo
   echo "Just execute script, It will be make your sensu go or sensu agent"
   echo "Thank you."
   echo
   echo "Made by Rick00Kim <dreamx119@gmail.com>"
   echo
}

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
  read -p 'Are you sure?[y/n] - ' default_kind_confirm
  if [ $default_kind_confirm != "y" ]; then
    exit 1
  else
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
    echo "Master start"
    ;;
  Slave)
    echo "Slave start"
    ;;
  *)
    echo "A problem has occurred. Please execute script again..."
    exit 1
    ;;
esac
