#!/bin/bash

app_name=mongod

source ./common.sh

check_root

cp $script_dir/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
validate $? "Created Mongo repo"

dnf install mongodb-org -y &>>$log_file
validate $? "Installing Mongodb"

service_start $app_name

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf &>>$log_file
validate $? "Allow remote connections"

service_restart $app_name


