#!/bin/bash

source ./common.sh
app_name=shipping

check_root
app_setup
java_setup
service_setup


dnf install mysql -y &>>$LOG_FILE
VALIDATE $? " installing mysql"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities' &>>$LOG_FILE


if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    VALIDATE $? " loading schema.sql"

    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE
    VALIDATE $? " loading app-user.sql"

    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
    VALIDATE $? " loading master-data.sql"
else
    echo "databse already loaded $Y...SKIPPING $N"

fi
app_restart
print_total_time