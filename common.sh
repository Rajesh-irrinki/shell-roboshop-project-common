#!/bin/bash

user_id=$UID 
log_folder=/var/log/roboshop
log_file=$log_folder/$0.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
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

maven_install() {
    dnf install maven -y &>>$log_file
    validate $? "Installing maven"
}

java_build() {
    cd /app &>>$log_file
    mvn clean package &>>$log_file
    mv target/shipping-1.0.jar $app_name.jar &>>$log_file
}

nodejs_build() {
    cd /app &>>$log_file
    npm install &>>$log_file
    validate $? "Installing dependencies"
}

python_build() {
    cd /app &>>$log_file
    pip3 install -r requirements.txt &>>$log_file
    validate $? "Installing dependencies"
}

go_build() {
    cd /app &>>$log_file
    go mod init dispatch &>>$log_file
    validate $? "Initializing module"

    go get &>>$log_file
    validate $? "Downloading dependencies" 

    go build&>>$log_file
    validate $? "Build creation"
}

app_setup() {

    id roboshop &>>$log_file
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$log_file
        validate $? "roboshop user creation"
    else
        echo -e " "[ $(date '+%F %T') ] " roboshop user already exists ... $Y SKIPPING $N" | tee -a $log_file
    fi

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

systemd_setup() {
    cp $script_dir/$1.service /etc/systemd/system/$1.service &>>$log_file
    validate $? "$1 systemd service creation"
}

daemon_reload() {
    systemctl daemon-reload &>>$log_file
    validate $? "Daemon reload"
}

service_start() {
    systemctl enable $1 &>>$log_file
    systemctl start $1 &>>$log_file
    validate $? "Enabling and Starting $app_name"
}

service_restart() {
    systemctl restart $1 &>>$log_file
    validate $? "Restart $1 service"
}

execution_time( ){
    end_time=$(date +%s)
    echo " "[ $(date '+%F %T') ] " script execution time $(($end_time - $start_time))"
}