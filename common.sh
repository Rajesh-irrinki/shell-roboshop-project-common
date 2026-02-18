#!/bin/bash

user_id=$UID 
log_folder=/var/log/roboshop
log_file=$log_folder/$0.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
script_dir=$(cd "$(dirname "$0")" && pwd)

mkdir -p $log_folder

check_root() {
    if [ $user_id -ne 0 ]; then
        echo -e "$R Please run the script with root access $N " | tee -a $log_file
        exit 1
    fi
}

validate() {
    if [ $1 -eq 0 ]; then
      echo -e "$2  ... $G SUCCESS $N" | tee -a  $log_file
    else
      echo -e "$2  ... $R FAILED $N " | tee -a $log_file
      exit 1
    fi
}

service_start() {
    systemctl enable $app_name &>>$log_file
    systemctl start $app_name &>>$log_file
    validate $? "Enabling and Starting $app_name"
}

service_restart() {
    systemctl restart $app_name &>>$log_file
    validate $? "Restart $app_name service"
}