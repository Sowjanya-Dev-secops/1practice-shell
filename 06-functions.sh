#!/bin/bash
USERID=$( id -u )
if [ $USERID -ne 0 ];then
    echo "please proceed with root previlage"
    exit 1
fi

VALIDATE()
{
    if [ $? -ne 0 ];then
        echo "error: nginx is not installed"
    else
        echo "installation of nginx is successful"

}
dnf install nginx -y
VALIDATE $? "nginx"


