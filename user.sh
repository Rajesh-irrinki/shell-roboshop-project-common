#!/bin/bash

app_name=user
script_dir=$(cd "$(dirname "$0")" && pwd)

source $script_dir/common.sh

check_root

nodejs_setup 

app_setup

nodejs_build

systemd_setup $app_name

daemon_reload

service_start $app_name

execution_time


