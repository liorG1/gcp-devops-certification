#!/bin/bash

# הגדרת אזור - שנה את זה למה שמופיע לך בדף המעבדה
ZONE="us-central1-a" 
CLUSTER_NAME="cloud-trace-demo"

echo "=== 1. Enabling GKE API ==="
gcloud services enable container.googleapis.com

echo "=== 2. Creating GKE Cluster (This takes a few minutes) ==="
gcloud container clusters create $CLUSTER_NAME --zone $ZONE

echo "=== 3. Getting Cluster Credentials ==="
gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE

echo "=== 4. Verifying Cluster Nodes ==="
kubectl get nodes

echo "=== 5. Cloning Sample App & Deploying ==="
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
cd python-docs-samples/trace/cloud-trace-demo-app-opentelemetry
./setup.sh

echo "=== Setup Complete! ==="
echo "To generate a trace, run the following command in your Cloud Shell:"
echo "curl \$(kubectl get svc -o=jsonpath='{.items[?(@.metadata.name==\"cloud-trace-demo-a\")].status.loadBalancer.ingress[0].ip}')"