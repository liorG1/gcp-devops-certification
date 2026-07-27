cat << 'EOF' > README.md
# GCP DevOps: Cloud Monitoring & Ops Agent with Apache

## Overview
This lab covers the automated deployment, configuration, and monitoring of an Apache Web Server running on a Google Compute Engine VM instance using the **Google Cloud Ops Agent**. 

The entire setup (VM creation, Firewall rules, and Software setup) is fully automated using **Terraform**.

## Objectives
1. **Automated Infrastructure**: Provision a Compute Engine VM (`e2-small`) using Terraform.
2. **Firewall Architecture**: Configure network security rules to allow inbound HTTP (80) and HTTPS (443) traffic.
3. **Application Deployment**: Install Apache2 Web Server via a startup script.
4. **Telemetry Ingestion**: Configure the GCP Ops Agent (`config.yaml`) to capture Apache access logs, error logs, and performance metrics.
5. **Traffic Generation**: Simulate realistic user activity to populate the predefined Apache Overview Dashboard.

---

## Infrastructure As Code (Terraform Setup)

The architecture is written inside `main.tf`. The configuration automates the creation of the virtual machine and executes the application setup using a custom `metadata_startup_script`.

---

## Deployment & Verification Steps

### 1. Provision Infrastructure
Run the following commands inside the repository directory:
```bash
terraform init
terraform apply -auto-approve