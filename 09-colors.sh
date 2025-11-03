#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"

USERID=$( id -u )
if [ $USERID -ne 0 ];then
    echo " please proceed with root user previliage"
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
for package in $@
do
    dnf install $package -y
    VALIDATE $? "$package"
done
