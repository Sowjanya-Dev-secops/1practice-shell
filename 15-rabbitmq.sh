#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
START_TIME=$(date +%s)
MONGODB_HOST=mongodb.msdevsecops.fun
LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
SCRIPT_DIR=$PWD
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" # /var/log/shell-script/16-logs.log

mkdir -p $LOGS_FOLDER
echo "Script started executed at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root privelege"
    exit 1 # failure is other than 0
fi

VALIDATE(){ # functions receive inputs through args just like shell script args
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N" | tee -a $LOG_FILE
    fi
}

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOG_FILE
VALIDATE $? "Copy rabbitmq"

dnf install rabbitmq-server -y  &>>$LOG_FILE
VALIDATE $? "Install rabbitmq server"

systemctl enable rabbitmq-server  &>>$LOG_FILE
VALIDATE $? "enable rabbitmq"

systemctl start rabbitmq-server  &>>$LOG_FILE
VALIDATE $? "start rabbitmq"

rabbitmqctl add_user roboshop roboshop123  &>>$LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>$LOG_FILE
VALIDATE $? "setting up permissions"

END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))
echo -e "Script executed in: $Y $TOTAL_TIME Seconds $N"