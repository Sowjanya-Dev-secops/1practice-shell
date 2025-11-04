#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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

dnf module disable nodejs -y
VALIDATE $? "Disable nodejs"  

dnf module enable nodejs:20 -y
VALIDATE $? "Enable nodejs"

dnf install nodejs -y
VALIDATE $? "Enable nodejs"

id roboshop
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
    VALIDATE $? "creating system user"
else
    echo -e "user already exist....$G Skipping$N"
fi

mkdir -p /app 
VALIDATE $? "creating directory"

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip  
VALIDATE $? "Downloading the Application"

cd /app 
VALIDATE $? "changing directory"

rm -rf /app/*
VALIDATE $? "remove old existing code"

unzip /tmp/cart.zip
VALIDATE $? "unzip the catalouge"

npm install
VALIDATE $? "install dependencies"

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service
VALIDATE $? "copy catalouge services"

systemctl daemon-reload
systemctl enable cart 
VALIDATE $? "enable cart"

systemctl start cart
VALIDATE $? "start cart"



systemctl restart cart
VALIDATE $? "Restarted cart"