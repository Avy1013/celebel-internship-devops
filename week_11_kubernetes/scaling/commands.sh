
# Step 1: Apply the Deployment
kubectl apply -f deployment.yaml

# Step 2: Install Metrics Server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Step 3: Verify Metrics Server Installation
kubectl get deployment metrics-server -n kube-system

# Step 4: Apply the HPA Configuration
kubectl apply -f hpa.yaml

# Step 5: Get HPA Status
kubectl get hpa

# Step 6: Describe the HPA
kubectl describe hpa example-hpa
