# GKE Deployments Management Lab 🚀

This repository captures a comprehensive practical lab for managing application deployments within Google Kubernetes Engine (GKE), focusing on advanced release patterns: **Blue-Green Deployments** and **Canary Releases**.

---

## 🏗️ Technical Architecture Overview

In this lab, we successfully hosted a modern, scalable web application (**`fortune-app`**) on a managed GKE cluster. The cluster architecture spans a customized, high-performance Node Pool configured to dynamically distribute containerized workloads and route public traffic smoothly.

   [ Public Internet ]
            │
            ▼
  [ LoadBalancer Service ]
   (app: fortune-app)
    ├── 70% Traffic ──► [ Green Deployment (v2.0.0) ]  (track: stable)
    └── 30% Traffic ──► [ Canary Deployment (v1.0.0) ] (track: canary)

---

## 🛠️ Complete Linux / Kubectl Command Execution Log

Below is the structured order of commands executed natively in the environment to scale infrastructure, apply configurations, debug runtime faults, and balance dynamic traffic routing.

### 1. Advanced Infrastructure Scalability (Node Pools)
When running intensive testing, the original `default-pool` ran out of compute resources. We scaled out the cluster seamlessly by generating a robust, compute-optimized Node Pool and removing the constrained resource constraints.
```bash
# Provision a robust machine pool to accommodate horizontal pods
gcloud container node-pools create strong-pool \
    --cluster=gke-lab-cluster \
    --machine-type=e2-standard-2 \
    --num-nodes=2 \
    --zone=us-west4-a

# Deprovision the underpowered default infrastructure
gcloud container node-pools delete default-pool \
    --cluster=gke-lab-cluster \
    --zone=us-west4-a \
    --quiet
2. Validating Runtime Environment State
Bash
# Inspect the active workloads and observe active state
kubectl get pods

# Deep-dive verification into pod tags and attached labels
kubectl get pods --show-labels
3. Deploying the Decoupled Routing Layer (Services)
Instead of hardcoding a specific runtime track (such as stable or canary), we deployed a generalized Service Selector looking exclusively for app: fortune-app. This configuration decouples routing from version tags.

Bash
# Apply the canary-agnostic external routing configuration
kubectl apply -f services/fortune-app-canary-routing.yaml

# Monitor dynamic backends attached to the service mesh load balancer
kubectl get endpoints fortune-app
4. Dynamic Live Cluster Updates (Imperative Controls)
During testing, utilizing a hypothetical 3.0.0 container image caused an infrastructure stall (ImagePullBackOff) due to registry constraints. We applied live corrective operations to fall back to a stable legacy container while maintaining consistent tags.

Bash
# Imperatively patch the active deployment container image descriptor
kubectl set image deployment/fortune-app-canary fortune-app=us-central1-docker.pkg.dev/qwiklabs-resources/spl-lab-apps/fortune-service:1.0.0

# Update runtime context environment variables within the cluster ecosystem
kubectl set env deployment/fortune-app-canary APP_VERSION=1.0.0
5. Automated Traffic Verification Test Loop
Bash
# Execute a localized curl iteration to assert proportional load-distribution
for i in {1..10}; do curl -s [http://34.125.204.118](http://34.125.204.118) | grep version; done
💡 Key Architectural Takeaways
Declarative vs. Imperative States (Configuration Drift): Using imperative syntax commands like kubectl set modifies the living state of an active cluster, creating a divergence from code configurations. True GitOps principles dictate modifying .yaml manifests before initiating an operational change.

Dynamic Service Selection: Kubernetes Services dynamically match backends using label tracking selectors. By widening selectors to evaluate a generic label (app: fortune-app), traffic auto-balances proportionately across multiple running versions.

Graceful Failure Domains: When the Canary release hit an ImagePullBackOff fault, the production environment faced zero impact. The fortune-app load balancer instantly protected end-users by continuing to stream traffic to healthy stable endpoints.

🧼 Resource De-provisioning Clean-Up
To terminate public-facing load balancers and compute nodes preventing resource billing overheads:

Bash
gcloud container clusters delete gke-lab-cluster --zone us-west4-a --quiet