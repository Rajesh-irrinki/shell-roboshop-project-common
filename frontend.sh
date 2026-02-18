#!/bin/bash

app_name=frontend

source ./common.sh

check_root

dnf module disable nginx -y &>>$log_file
dnf module enable nginx:1.24 -y &>>$log_file
dnf install nginx -y &>>$log_file
validate $? "Installing Nginx"

service_start nginx

rm -rf /usr/share/nginx/html/*  &>>$log_file
validate $? "Removing existing code" &>>$log_file

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$log_file
validate $? "Downloading frontend code" 

cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
validate $? "Unziping frontend code"

rm -rf /etc/nginx/nginx.conf &>>$log_file
validate $? "Removing Nginx configuration"

cp $script_dir/nginx.conf /etc/nginx/nginx.conf &>>$log_file
validate $? "Reverse Proxy config creation"

service_restart $app_name

execution_time

