#!/bin/bash

app_name=user

source ./common.sh

check_root

nodejs_setup 

user_creation roboshop

app_setup

cd /app
validate $? "Moving to app directory" 

npm install &>>$log_file
validate $? "Installing dependencies"

cp $script_dir/user.service /etc/systemd/system/user.service
validate $? "User systemd service creation"

daemon_reload

service_start

execution_time


