# GCP Cloud Monitoring: Qwik Start Lab

## Overview
This lab demonstrates how to monitor a Compute Engine virtual machine (VM) instance using Google Cloud Operations Suite (Cloud Monitoring and Cloud Logging). 

## Steps Completed:
1. Created a Compute Engine `e2-medium` instance named `lamp-1-vm` in `us-west4-a` via gcloud CLI.
2. Installed Apache2 HTTP server and verified public access via External IP.
3. Configured VPC Firewall rules to allow Ingress HTTP traffic on Port 80.
4. Installed the Google Cloud Ops Agent on the VM instance to stream metrics and logs.
5. Configured an Uptime Check (`Lamp Uptime Check`) to monitor service availability.
6. Created an Alerting Policy (`Inbound Traffic Alert`) based on network interface traffic.
7. Built a Custom Dashboard (`Cloud Monitoring LAMP Qwik Start Dashboard`) displaying CPU Load and Received Packets widgets.

Completed successfully using VS Code, WSL, and Personal GCP Account.
