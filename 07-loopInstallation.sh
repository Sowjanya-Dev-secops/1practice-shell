#!/bin/bash
USERID=$( id -u )
if [ $USERID -ne 0 ]; then 
    echo "plaese proceed with root user previlage "
    exit 1
fi
VALIDATE(){
    if [ $1 -ne 0 ];then
        echo "error: $2 is not installed"
    else
        echo "$2 installation is succecssful"
    fi
}
for package in $@
do
    dnf install $package -y
    VALIDATE $? "$package"
done