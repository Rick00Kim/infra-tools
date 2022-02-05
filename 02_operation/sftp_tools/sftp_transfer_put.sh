#!/bin/bash

# Script name : Transfer tool(PUT)
# Description : Put file(s) to web server
# Version : [1.0.0]
# Writer : Rick_Kim dreamx119@gmail.com

# Define local function
function create_log_comment() {
    echo "`date +%Y%m%d.%T`: $1" >> $LOG_FILE
}

# Start [Check arguments]
while getopts "u:a:f:" option  
do
    case $option in
        u)
            SFTP_USER="$OPTARG"
            ;;
        a)
            SFTP_ADDRESS="$OPTARG"
            ;;
        f)
            TARGET_FOLDER="$OPTARG"
            ;;
    esac
done

shift $(( $OPTIND -1 ))

if [ -z "$SFTP_USER" ]; then
    echo "SFTP_USER should not be null"
    exit 1
fi

if [ -z "$SFTP_ADDRESS" ]; then
    echo "SFTP_ADDRESS should not be null"
    exit 1
fi
# End [Check arguments]

# Start [Set variables for script]
export SFTP_PATH=$(which sftp)
## Set App name
export APP_NAME=`basename "$0" .sh`
## Set log variables
export LOG_DIRECTORY=./logs/$APP_NAME
export LOG_FILE=$LOG_DIRECTORY/"$SFTP_USER"_"$SFTP_ADDRESS"_`date +%Y%m%d`.log
## Set transfer variables
if [ -z $TARGET_FOLDER ]; then
    PUT_DIRECTORY=/home/$SFTP_USER/FTP_folder
else
    PUT_DIRECTORY=/home/$SFTP_USER/$TARGET_FOLDER
fi
# End [Set variables for script]

# Start [Check log directory and file]
if [[ ! -d "$LOG_DIRECTORY" ]]; then
    echo "[$LOG_DIRECTORY] does not exists."
    echo Create directory...
    mkdir -p $LOG_DIRECTORY
fi
# End [Check log directory and file]

# Add comment for start app
create_log_comment "Start transfer file(s) to $SFTP_ADDRESS"

# Process putting file(s) by sftp
for var in $* 
do
$SFTP_PATH $SFTP_USER@$SFTP_ADDRESS << CMD >> $LOG_FILE
cd $PUT_DIRECTORY
put -r $var
quit
CMD
done
echo $?

# Add comment for end app
create_log_comment "End transfer"

