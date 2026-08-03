#!/bin/bash

# הגדרת משתנים קבועים
MONITORING_PROJECT="terraform-learning-503012"
WORKER_1_PROJECT="lior-worker-1-4477"
WORKER_2_PROJECT="lior-worker-2-4477"
ZONE="us-central1-a"

echo "=== 1. מאפשר חיוב ו-Compute API ב-Worker 1 ==="
gcloud config set project $WORKER_1_PROJECT
gcloud services enable compute.googleapis.com

echo "=== 2. יוצר שרת ומגדיר תגיות ב-Worker 1 ==="
gcloud compute instances create worker-1-server \
    --zone=$ZONE \
    --machine-type=e2-medium \
    --image-family=debian-12 \
    --image-project=debian-cloud \
    --tags=http-server \
    --labels=component=frontend,stage=dev \
    --metadata=startup-script="sudo apt-get update && sudo apt-get install -y nginx"

echo "=== 3. מאפשר חיוב ו-Compute API ב-Worker 2 ==="
gcloud config set project $WORKER_2_PROJECT
gcloud services enable compute.googleapis.com

echo "=== 4. יוצר שרת ומגדיר תגיות ב-Worker 2 ==="
gcloud compute instances create worker-2-server \
    --zone=$ZONE \
    --machine-type=e2-medium \
    --image-family=debian-12 \
    --image-project=debian-cloud \
    --tags=http-server \
    --labels=component=frontend,stage=test \
    --metadata=startup-script="sudo apt-get update && sudo apt-get install -y nginx"

echo "=== 5. פותח פיירוול לתעבורת אינטרנט בשני הפרויקטים ==="
gcloud compute firewall-rules create default-allow-http --project=$WORKER_1_PROJECT --allow=tcp:80 --target-tags=http-server
gcloud compute firewall-rules create default-allow-http --project=$WORKER_2_PROJECT --allow=tcp:80 --target-tags=http-server

# החזרת ה-CLI לפרויקט הניטור המרכזי בסיום
gcloud config set project $MONITORING_PROJECT

echo "=== התשתית הוקמה בהצלחה! ==="