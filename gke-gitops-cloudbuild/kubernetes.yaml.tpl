apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-cloudbuild-app
  labels:
    app: hello-cloudbuild-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-cloudbuild-app
  template:
    metadata:
      labels:
        app: hello-cloudbuild-app
    spec:
      containers:
      - name: hello-cloudbuild-app
        image: us-west4-docker.pkg.dev/COMMIT_SHA
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: hello-cloudbuild-app
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: hello-cloudbuild-app