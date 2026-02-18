#!/bin/bash

app_name=rabbitmq
script_dir=$(cd "$(dirname "$0")" && pwd)

source $script_dir/common.sh

check_root

cp $script_dir/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$log_file
validate $? "Creating Rabbitmq.repo file"

dnf install rabbitmq-server -y &>>$log_file
validate $? "Installing rabbitmq"

service_start rabbitmq-server 

rabbitmqctl add_user roboshop roboshop123 &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
validate $? "Adding user and set permissions"

execution_time
