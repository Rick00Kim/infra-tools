#!/bin/bash

# Script name : connectOracle
# Description : Connect to oracle
# Version : [1.0.0]
# Writer : Rick_Kim dreamx119@gmail.com

# Define local function
function connect() {
   echo "Connect using TNS-> "$1
   sqlplus $ORACLE_SHEMA@$1
}

# Start [Check arguments]
while getopts "s:t:" option  
do
    case $option in
        s)
            ORACLE_SHEMA="$OPTARG"
            ;;
        t)
            TNS_FLG="$OPTARG"
            ;;
    esac
done

shift $(( $OPTIND -1 ))

# If ORACLE_SHEMA is not exists, exit program.
if [ -z "$ORACLE_SHEMA" ]; then
    echo "Oracle shema should not be null"
    exit 1
fi

# If TNS_FLG is not setted or is no, get specfic TNS_FLG by user input.
if [ -z "$TNS_FLG" -o "$TNS_FLG" = "no" ]; then
    echo "Please write Target TNS sever"
    read
    TARGET_TNS=$(echo $REPLY)
fi

# Start [Set variables for script]
if [ -z $TNS_ADMIN ]; then
    TNS_DIR=$ORACLE_HOME/network/admin
else
    TNS_DIR=$TNS_ADMIN
fi

# Set Target tns, when TARGET_TNS is not exists.
if [ -z $TARGET_TNS ]; then
    # Get all defined TNS.
    array=(`cat $TNS_DIR/tnsnames.ora | grep "(.*)" | awk -F '=' '{print $1}' | sed 's/ /\n/g'`)

    # Show all TNS.
    echo "=========TNS Informations=========="
    for i in "${!array[@]}"
    do
        echo "$(($i+1))" -  "${array[$i]}"
    done

    # Get TNS number by user input.
    echo "Choose TNS"
    read
    TARGET_TNS=${array[$(($REPLY-1))]}
fi

# Connect to Oracle shema.
connect $TARGET_TNS


