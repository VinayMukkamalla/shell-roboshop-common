#!/bin/bash

source ./common.sh

dnf module disable nginx -y &>>$LOG_FILE
VALIDATE $? "disabling default nginx"

dnf module enable nginx:1.24 -y &>>$LOG_FILE
VALIDATE $? "enabling nginx version 1.24"

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "installing nginx"

systemctl enable nginx  &>>$LOG_FILE
VALIDATE $? "enabling nginx "

systemctl start nginx &>>$LOG_FILE
VALIDATE $? "starting nginx "

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? " removing default html code from /usr/share/nginx/html path"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOG_FILE
VALIDATE $? "Downloading frontend application"

cd /usr/share/nginx/html &>>$LOG_FILE
VALIDATE $? "changing to /usr/share/nginx/html path"

unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "unzipping frontend application"

rm -rf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "removing default nginx configuration"

cp $DIR_PATH/nginx.conf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "adding nginx configuration "

systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "restarting nginx"

print_total_time