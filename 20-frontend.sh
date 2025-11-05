#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.daws86s.fun
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

dnf module disable nginx -y &>>$LOG_FILE
dnf module enable nginx:1.24 -y &>>$LOG_FILE
dnf install nginx -y 
VALIDATE $? "install nginx"
systemctl enable nginx &>>$LOG_FILE
VALIDATE $? "enabling nginx"
systemctl start nginx &>>$LOG_FILE

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "remove deafault nginx"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOG_FILE
VALIDATE $? "downloading frontend code"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "unzip nginx code"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "copy nginx config"

systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "restart nginx"