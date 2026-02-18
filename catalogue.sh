#!/bin/bash

app_name=catalogue
mongodb_host=mongodb.rajeshirrinki.online

source ./common.sh

check_root

nodejs_setup

user_creation roboshop

app_setup 

cd /app 
npm install &>>$log_file
validate $? "Installing Dependencies"

cp $script_dir/catalogue.service /etc/systemd/system/catalogue.service &>>$log_file
validate $? "Catalogue systemd service creation"

daemon_reload

service_start 

cp $script_dir/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
validate $? "Mongo.repo creation"

dnf install mongodb-mongosh -y &>>$log_file
validate $? "mongo shell installation"

index=(mongosh -h $mongodb_host --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")' )
if [ $index -le 0 ]; then
    mongosh --host $mongodb_host </app/db/master-data.js
    validate $? "Master data loading"
else
    echo -e " "[ $(date '+%F %T') ]" "Master data already exists ... $Y SKIPPING $N" | tee -a $log_file
fi    






