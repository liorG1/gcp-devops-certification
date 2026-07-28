# הגדרת אזור מקומי ופרויקט אוטומטי
export REGION="me-west1"
export ZONE="me-west1-a"
export PROJECT_ID=$(gcloud config get-value project)

# 1. יצירת רשת ה-VPC במצב Custom
gcloud compute networks create vpc-net --subnet-mode=custom

# 2. יצירת ה-Subnet עם הפעלת Flow Logs
gcloud compute networks subnets create vpc-subnet \
    --network=vpc-net \
    --region=$REGION \
    --range=10.1.3.0/24 \
    --enable-flow-logs

# 3. יצירת חומת האש (Firewall Rule) ל-HTTP ו-SSH
gcloud compute firewall-rules create allow-http-ssh \
    --network=vpc-net \
    --allow=tcp:80,tcp:22 \
    --target-tags=http-server \
    --source-ranges=0.0.0.0/0

# 4. יצירת שרת ה-Web עם סקריפט התקנה אוטומטי של Apache
gcloud compute instances create web-server \
    --zone=$ZONE \
    --machine-type=e2-micro \
    --network=vpc-net \
    --subnet=vpc-subnet \
    --tags=http-server \
    --metadata=startup-script='#!/bin/bash
    sudo apt-get update
    sudo apt-get install apache2 -y
    echo "<!doctype html><html><body><h1>Hello World!</h1></body></html>" | sudo tee /var/www/html/index.html'