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

dnf module disable nginx -y &>>$log_file
dnf module enable nginx:1.24 -y &>>$log_file
dnf install nginx -y &>>$log_file
VALIDATE $? "install nginx"
systemctl enable nginx &>>$log_file
VALIDATE $? "enabling nginx"
systemctl start nginx &>>$log_file

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "remove deafault nginx"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$log_file
VALIDATE $? "downloading frontend code"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$log_file
VALIDATE $? "unzip nginx code"

cp $Script_Dir/nginx.conf /etc/nginx/nginx.conf &>>$log_file
systemctl restart nginx &>>$log_file
VALIDATE $? "restart nginx"