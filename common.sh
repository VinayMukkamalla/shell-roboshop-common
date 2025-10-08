user=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOG_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
START_TIME=$(date +%s)
mkdir -p $LOG_FOLDER
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
DIR_PATH=$PWD
MONGODB_HOST=mongodb.vinaymukkamalla.fun

echo " script started execution at : $(date)" | tee -a $LOG_FILE

check_root(){
    if [ $user -gt 0 ]; then
        echo "ERROR:: you are not allowed to run this script use root privilege"
        exit 1
    fi
}

nodejs_setup(){
    dnf module disable nodejs -y &>>$LOG_FILE
    VALIDATE $? "disabling nodejs "
    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? "enabling nodejs version 20 "
    dnf install nodejs -y &>>$LOG_FILE
    VALIDATE $? "installing nodejs "
    npm install &>>$LOG_FILE
    VALIDATE $? "installing dependencies "
}

app_setup(){
    id roboshop  &>>$LOG_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
        VALIDATE $? "adding system user "
    else    
        echo -e "user already exists $Y ...Skipping $N"
    fi
    mkdir -p /app &>>$LOG_FILE
    VALIDATE $? "creating app directory "
    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE
    VALIDATE $? "Downloading $app_name application"
    cd /app &>>$LOG_FILE
    VALIDATE $? "changing to /app Directory"
    rm -rf /app/*  &>>$LOG_FILE
    VALIDATE $? "removing existing $app_name application code"
    unzip /tmp/$app_name.zip &>>$LOG_FILE
    VALIDATE $? "unzipping $app_name application"
}

service_setup(){
    cp $DIR_PATH/$app_name.service /etc/systemd/system/$app_name.service        
    systemctl daemon-reload
    systemctl enable $app_name &>>$LOG_FILE
    VALIDATE $? "enlabling $app_name "
    systemctl start $app_name &>>$LOG_FILE
    VALIDATE $? "starting $app_name service "

}

java_setup(){
    dnf install maven -y &>>$LOG_FILE
    VALIDATE $? "Installing maven"
    mvn clean package &>>$LOG_FILE
    VALIDATE $? "packaging application in target directory"
    mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE
    VALIDATE $? " renaming jar application file"
}

python_setup(){
    dnf install python3 gcc python3-devel -y &>>$LOG_FILE
    VALIDATE $? "Installing python"
    pip3 install -r requirements.txt &>>$LOG_FILE
    VALIDATE $? "installing application dependencies"
}

app_restart(){
    systemctl restart $app_name
    VALIDATE $? "restarted $app_name service"
}

VALIDATE(){
    if [ $1 -gt 0 ]; then
        echo -e " $2 ..$R Failure $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e " $2 ..$G Success $N" | tee -a $LOG_FILE

    fi

}

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME-$START_TIME))
    echo "Total time taken to execute script : $TOTAL_TIME seconds"
}