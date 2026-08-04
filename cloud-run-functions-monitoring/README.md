# GCP Lab: Monitoring and Logging for Cloud Run Functions (GSP092)

## Overview
This repository contains the setup and solution for the GSP092 lab. It demonstrates deploying a Cloud Run function (2nd gen) and configuring Cloud Observability tools (Cloud Logging & Cloud Monitoring).

## Architecture & Resources
- **Region**: `us-west4`
- **Runtime**: Node.js 22
- **Services**: Cloud Run, Cloud Logging, Cloud Monitoring
- **Load Generation**: Vegeta HTTP Load Testing Tool

## Steps Executed
1. **Deployed Cloud Run Function**: Created `helloworld` service on Cloud Run.
2. **Generated Traffic**: Sent 200 req/sec for 60 seconds using `vegeta`.
3. **Logs-based Metric**: Created `CloudRunFunctionLatency-Logs` distribution metric tracking `httpRequest.latency`.
4. **Monitoring Dashboard**: Visualized execution metrics and latency histograms.
