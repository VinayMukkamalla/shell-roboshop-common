#!/bin/bash

source ./common.sh

check_root

cp $DIR_PATH/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding mongo repo"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "Installing mongodb server"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "enabling mongodb server"

systemctl start mongod &>>$LOG_FILE
VALIDATE $? "starting mongodb server"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing access to mongodb"

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "restarting mongodb server"

print_total_time