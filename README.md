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
