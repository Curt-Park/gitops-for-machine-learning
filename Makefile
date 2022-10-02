PROFILE_NAME=gitops-for-ml
REMOTE_REPO=$(shell git remote get-url origin)
REVISION=$(shell git rev-parse --abbrev-ref HEAD)

# k8s cluster
cluster:
	minikube start driver=docker --profile=$(PROFILE_NAME)
	kubectl get nodes
	# install argo-cd
	helm repo add argo-cd https://argoproj.github.io/argo-helm
	helm dependency build charts/argo-cd
	helm install argo-cd charts/argo-cd

tunnel:
	# for loadbalancer access
	sudo minikube tunnel --profile=$(PROFILE_NAME)

finalize:
	minikube delete --profile=$(PROFILE_NAME)

# apps
login-argocd:
	ARGOCD_PW=$(kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d) &&\
			  echo "ArgoCD's password is... ${ARGOCD_PW}" && \
			  argocd login localhost:8080 --username admin --password $(ARGOCD_PW) --insecure
	argocd repo add ${REMOTE_REPO} --ssh-private-key-path ~/.ssh/id_ecdsa

argo-cd:  # not compatible with node-ip
	argocd app create argo-cd \
		--repo $(REMOTE_REPO) --revision $(REVISION) \
		--path charts/argo-cd \
		--dest-server https://kubernetes.default.svc \
		--dest-namespace default
	argocd app sync argo-cd
