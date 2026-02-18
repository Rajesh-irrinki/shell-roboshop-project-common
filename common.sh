#!/bin/bash

user_id=$UID 
log_folder=/var/log/roboshop
log_file=$log_folder/$0.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
script_dir=$(cd "$(dirname "$0")" && pwd)
start_time=$(date +%s)
echo "Script execution started at : $(date '+%F %T' )"

mkdir -p $log_folder

check_root() {
    if [ $user_id -ne 0 ]; then
        echo -e " "[ $(date '+%F %T') ]" $R Please run the script with root access $N " | tee -a $log_file
        exit 1
    fi
}

validate() {
    if [ $1 -eq 0 ]; then
      echo -e " "[ $(date '+%F %T') ]"  $2  ... $G SUCCESS $N" | tee -a  $log_file
    else
      echo -e " "[ $(date '+%F %T') ]"  $2  ... $R FAILED $N " | tee -a $log_file
      exit 1
    fi
}

nodejs_setup() {
    dnf module disable nodejs -y &>>$log_file
    dnf module enable nodejs:20 -y &>>$log_file
    validate $? "Enabled Nodejs 20 version"

    dnf install nodejs -y &>>$log_file
    validate $? "Installing nodejs"
}

user_creation() {
    id $1 &>>$log_file
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" $1 &>>$log_file
        validate $? "$1 user creation"
    else
        echo -e " "[ $(date '+%F %T') ] " $1 user already exists ... $Y SKIPPING $N" | tee -a $log_file
    fi
}

app_setup() {

    mkdir -p /app &>>$log_file
    validate $? "App directory creation"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$log_file
    validate $? "Downloading $app_name code"

    cd /app &>>$log_file
    validate $? "Moving to app directory" 

    rm -rf /app/* &>>$log_file
    validate $? "Removing existing code in app directory"

    unzip /tmp/$app_name.zip &>>$log_file
    validate $? "Unziping $app_name code"

}

daemon_reload() {
    systemctl daemon-reload &>>$log_file
    validate $? "Daemon reload"
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

execution_time( ){
    end_time=$(date +%s)
    echo "scripti execution time $(($end_time - $start_time))"
}