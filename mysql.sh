#!/bin/bash

source ./common.sh

check_root

dnf install mysql-server -y >>$LOG_FILE
VALIDATE $? "Installing mysql server"

systemctl enable mysqld >>$LOG_FILE
VALIDATE $? "enabling mysql server"

systemctl start mysqld  >>$LOG_FILE
VALIDATE $? "starting mysql server"


mysql_secure_installation --set-root-pass RoboShop@1 >>$LOG_FILE
VALIDATE $? "setting up username and password"

print_total_time