# Use kustomize to generate single yaml for tekton
for i in tekton; do mkdir -p templated; kustomize build ./$i > templated/$i.yaml; done

# Create required namespaces
kubectl create ns tekton-pipelines
kubectl create ns test-infra
kubectl create ns test-workloads

# Apply CRDs
kubectl apply -f crds/tekton.yaml
kubectl apply -f crds/tekton-dashboard.yaml
kubectl apply -f crds/tekton-triggers.yaml

# Apply all tekton resources
kubectl apply -f templated/tekton.yaml
