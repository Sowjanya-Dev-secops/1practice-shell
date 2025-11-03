#!/bin/bash
LOG_FOLDER="/var/log/1practie-shell"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
mkdir -p $LOG_FOLDER
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
echo "$LOG_FILE"