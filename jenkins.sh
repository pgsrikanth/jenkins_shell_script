#!/bin/bash

USERID=$(id -u)
LOG_FILE=/tmp/gow
R="\e[31m"
G="\e[32m"
N="\e[0m"

VALIDATE(){
if [ $1 -ne 0 ]; then
    echo -e "$2 is ..... $R failure $N" 2>&1 | tee -a $LOG_FILE
	exit 1
else
    echo -e "$2 is ..... $G success $N" 2>&1 | tee -a $LOG_FILE
fi
}

#check user is root or not
if [ $USERID -ne 0 ]; then
    echo "you are not a root user, you need permision"
	exit 1
fi

yum update &>>$LOG_FILE
VALIDATE $? "updating yum"

wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo &>>$LOG_FILE
VALIDATE $? "adding jenkins repo"

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key &>>$LOG_FILE
VALIDATE $? "importing key"

yum upgrade -y &>>$LOG_FILE
VALIDATE $? "upgrading yum"

dnf install java-11-amazon-corretto -y &>>$LOG_FILE
VALIDATE $? "installing java"

yum install jenkins -y &>>$LOG_FILE
VALIDATE $? "installing jenkins"

systemctl enable jenkins &>>$LOG_FILE
VALIDATE $? "enabling jenkins"

systemctl start jenkins &>>$LOG_FILE
VALIDATE $? "start jenkins"

systemctl status jenkins &>>$LOG_FILE
VALIDATE $? "jenkins status"