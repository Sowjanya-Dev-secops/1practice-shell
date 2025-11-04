#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
USERID=$( id -u )
if [ $USERID -ne 0 ];then
    echo " please proceed with root user previliage"
    exit 1
fi

LOG_FOLDER="/var/log/1practie-shell"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
mkdir -p $LOG_FOLDER
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"

VALIDATE(){
    if [ $1 -ne 0 ];then
        echo -e "$R error $N: $2 is not installed"
    else
        echo -e "$G success:$N $2 installation is succecssful"
    fi
}

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copy mongo repo file"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "mongodb-org"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "enable mongodb"

systemctl start mongod &>>$LOG_FILE
VALIDATE $? " start mongodb-org"

sed /s/127.0.0.1/0.0.0.0/ /etc/mongod.conf &>>$LOG_FILE
VALIDATE $? "conection to all ports"

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "reastart mongodb"