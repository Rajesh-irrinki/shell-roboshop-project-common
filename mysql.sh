#!/bin/bash

app_name=mysql

source ./common.sh

check_root

dnf install mysql-server -y &>>$log_file
validate $? "Installing mysql"

service_start mysqld

mysql_secure_installation --set-root-pass RoboShop@1 &>>$log_file
validate $? "Setup root password"

execution_time