#!/bin/bash

app_name=catalogue
script_dir=$(cd "$(dirname "$0")" && pwd)
mongodb_host=mongodb.rajeshirrinki.online

source $script_dir/common.sh

check_root

nodejs_setup

app_setup 

nodejs_build

systemd_setup $app_name

daemon_reload

service_start $app_name

cp $script_dir/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
validate $? "Mongo.repo creation"

dnf install mongodb-mongosh -y &>>$log_file
validate $? "mongo shell installation"

index=$(mongosh --host $mongodb_host --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")' )
if [ $index -le 0 ]; then
    mongosh --host $mongodb_host </app/db/master-data.js &>>$log_file
    validate $? "Master data loading"
else
    echo -e " "[ $(date '+%F %T') ] " Master data already exists ... $Y SKIPPING $N" | tee -a $log_file
fi 

execution_time






