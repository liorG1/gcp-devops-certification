# GSP338 - Monitor and Log with Google Cloud Observability: Challenge Lab

This repository contains the Terraform solution for the **GSP338** Challenge Lab.

## Architecture & Resources
- **Compute Instance (`video-queue-monitor`)**: e2-medium instance with service account and monitoring metrics setup.
- **Log-Based Metric (`high_resolution_video_uploads`)**: Tracks 4K and 8K video uploads from application logs.
- **Dashboard (`Media_Dashboard`)**: Custom observability dashboard showing queue sizes and video upload rates.
- **Alert Policy**: Triggers when high-resolution video upload rate exceeds threshold.

## Usage
```bash
terraform init
terraform apply -auto-approve
