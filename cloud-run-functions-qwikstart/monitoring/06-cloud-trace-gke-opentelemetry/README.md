# Lab 06: Cloud Trace with OpenTelemetry on GKE

This lab demonstrates distributed tracing using Google Cloud Trace and OpenTelemetry inside a Google Kubernetes Engine (GKE) cluster.

## Architecture & Objectives
- Deploy a 3-tier microservice application (`service-a`, `service-b`, `service-c`) written in Python.
- Generate distributed traces by hitting the external LoadBalancer IP of `service-a`.
- Analyze application latency, request flows, and performance bottlenecks via Cloud Trace Explorer.

## How to Run
1. Open Cloud Shell in the GCP console.
2. Copy the contents of `setup_lab.sh` to a file or upload it.
3. Make it executable: `chmod +x setup_lab.sh`
4. Run it: `./setup_lab.sh`