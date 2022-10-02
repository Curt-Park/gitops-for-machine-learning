# GitOps for Machine Learning
TBD


## Prerequisites

### 1. Package installation
- Install [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- Install [Helm](https://helm.sh/docs/intro/install/)
- Install [Argo-CD CLI](https://argo-cd.readthedocs.io/en/stable/getting_started/#2-download-argo-cd-cli)
- Install [Argo-Workflows CLI](https://github.com/argoproj/argo-workflows/releases/tag/v3.3.9)

You can install the all prerequites with [Homebrew](https://brew.sh/):
```bash
brew install minikube helm argocd argo
```

### 2. Fork and clone this repository
TBD

### 3. Register a SSH key
Create a new SSH key with ECDSA encryption and add it to [GitHub](https://github.com/settings/keys).

```bash
ssh-keygen -t ecdsa -b 521 -C "your@email-address.com"
cat ~/.ssh/id_ecdsa.pub  # show the public key
```

## Cluster setup

### 1. Kubernetes cluster initialization
```bash
make cluster # k8s cluster setup and argo-cd installation
make tunnel  # need to be active for the cluster's LoadBalancer access
```

### 2. Login ArgoCD and Add the repository
Check all argo-cd pods are in `Running` status.

```bash
kubectl get pods

# NAME                                                       READY   STATUS    RESTARTS   AGE
# argo-cd-argocd-application-controller-0                    1/1     Running   0          22m
# argo-cd-argocd-applicationset-controller-ccb4b5fc5-l2nwj   1/1     Running   0          22m
# argo-cd-argocd-dex-server-658b5c88f4-qzdl7                 1/1     Running   0          22m
# argo-cd-argocd-notifications-controller-67dcf4c8-dt28f     1/1     Running   0          22m
# argo-cd-argocd-redis-6d4576dbfb-77s6m                      1/1     Running   0          22m
# argo-cd-argocd-repo-server-744744d646-dx5zx                1/1     Running   0          22m
# argo-cd-argocd-server-f66f985c-xz5hl                       1/1     Running   0          22m
```

Login and add the repository to ArgoCD.

```bash
make init-argocd

# ARGOCD_PW= &&\
#                 argocd login localhost:8080 --username admin --password ******** --insecure
# 'admin:login' logged in successfully
# Context 'localhost:8080' updated
# argocd repo add git@github.com:Curt-Park/gitops-for-machine-learning.git --ssh-private-key-path ~/.ssh/id_ecdsa
# Repository 'git@github.com:Curt-Park/gitops-for-machine-learning.git' added
```

### 3. Install other apps
```bash
make argo-workflows
make minio
```

- Argo-CD: http://localhost:8080/
- Argo-Workflows: http://localhost:2746/
- MinIO: http://localhost:9000/

You can see the login information as follows.

- For ArgoCD:
```bash
# user: admin
# password:
kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
```

- For MinIO:
```bash
# AccessKey
kubectl get secret minio -o jsonpath='{.data.accesskey}' | base64 --decode

# SecretKey
kubectl get secret minio -o jsonpath='{.data.secretkey}' | base64 --decode
```

## Cluster shutdown
```bash
make finalize
```
