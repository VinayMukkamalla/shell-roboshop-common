#!/bin/bash

source ./common.sh
app_name=redis

check_root

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "disabling redis "
dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "enabling redis 7"
dnf install redis -y &>>$LOG_FILE
VALIDATE $? "Installing redis 7"
sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$LOG_FILE
VALIDATE $? "updating redis configuration allowing access"
systemctl enable redis &>>$LOG_FILE
VALIDATE $? "enabling redis "

app_restart

print_total_time