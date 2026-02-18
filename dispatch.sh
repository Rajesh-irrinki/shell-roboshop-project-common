#!/bin/bash

app_name=dispatch
script_dir=$(cd "$(dirname "$0")" && pwd)

source $script_dir/common.sh

check_root

dnf install golang -y &>>$log_file
validate $? "Installing Go"

app_setup $app_name

go_build

systemd_setup $app_name

daemon_reload

service_start $app_name

execution_time