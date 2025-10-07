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

echo " script started execution at : $(date)" | tee -a $LOG_FILE

check_root(){
    if [ $user -gt 0 ]; then
        echo "ERROR:: you are not allowed to run this script use root privilege"
        exit 1
    fi
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