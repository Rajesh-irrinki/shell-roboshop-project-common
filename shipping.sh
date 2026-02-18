#!/bin/bash

app_name=shipping
script_dir=$(cd "$(dirname "$0")" && pwd)
mysql_host=mysql.rajeshirrinki.online

source $script_dir/common.sh

check_root

maven_install

app_setup

java_build

systemd_setup $app_name

daemon_reload

service_start $app_name

dnf install mysql -y &>>$log_file
validate $? "Installing mysql client"

mysql -h $mysql_host -uroot -pRoboShop@1 -e 'use cities' &>>$log_file
if [ $? -ne 0 ]; then
    mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/schema.sql &>>$log_file
    mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/app-user.sql  &>>$log_file
    mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$log_file
    validate $? "Loaded data to mysql"
else
    echo -e "Data already loaded to mysql ... $Y SKIPPING $N" | tee -a $log_file
fi

service_restart $app_name

execution_time