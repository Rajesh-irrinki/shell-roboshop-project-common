#!/bin/bash

app_name=payment

source ./common.sh

check_root

dnf install python3 gcc python3-devel -y &>>$log_file
validate $? "Installing python"

app_setup $app_name

systemd_setup $app_name

daemon_reload

service_start $app_name

execution_time
