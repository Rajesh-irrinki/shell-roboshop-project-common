#!/bin/bash

app_name=cart

source ./common.sh

check_root

nodejs_setup

user_creation roboshop

app_setup

cd /app &>>$log_file
npm install
validate $? "Installing dependencies"

cp $script_dir/cart.service /etc/systemd/system/cart.service &>>$log_file
validate $? "Cart systemd service creation"

daemon_reload

service_start

execution_time
