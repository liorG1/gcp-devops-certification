# GCP DevOps GitOps Pipeline (GSP330)

This repository demonstrates a fully functioning CI/CD and GitOps pipeline built entirely on native Google Cloud services and GitHub.

## Architecture & Workflow
* **Code Repository:** Hosted on GitHub with dual branches (`dev` and `main`).
* **CI/CD Automation:** Google Cloud Build triggers automatically on repository pushes.
* **Artifact Registry:** Docker images are automatically built, versioned, and stored in Google Artifact Registry.
* **Orchestration:** Google Kubernetes Engine (GKE) cluster running two separate isolated environments via Namespaces (`dev` and `prod`).
* **Routing:** Applications are exposed via K8s `LoadBalancer` services with external IPs.
