#!/bin/bash

app_name=redis

source ./common.sh

check_root 

dnf module disable redis -y &>>$log_file
dnf module enable redis:7 -y &>>$log_file
validate $? "Enabling redis 7 version"

dnf install redis -y &>>$log_file
validate $? "Installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf 
validate $? "Allow remote connections"

service_start $app_name

execution_time