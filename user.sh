#!/bin/bash

app_name=user

source ./common.sh

check_root

nodejs_setup 

app_setup

nodejs_build

systemd_setup $app_name

daemon_reload

service_start $app_name

execution_time


