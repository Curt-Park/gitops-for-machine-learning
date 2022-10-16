PROFILE_NAME=gitops-for-ml
REMOTE_REPO=$(shell git remote get-url origin)
REVISION=$(shell git rev-parse --abbrev-ref HEAD)

# k8s cluster
cluster:
	# k8s cluster creation
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
	# cluster shutdown
	minikube delete --profile=$(PROFILE_NAME)

# apps
init-argocd:
	argocd login localhost:8080 \
		--username admin \
		--password $(shell kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d) \
		--insecure
	argocd repo add ${REMOTE_REPO} --ssh-private-key-path ~/.ssh/id_ecdsa

argo-cd:
	argocd app create argo-cd \
		--repo $(REMOTE_REPO) --revision $(REVISION) \
		--path charts/argo-cd \
		--dest-server https://kubernetes.default.svc \
		--dest-namespace default
	argocd app sync argo-cd

argo-workflows:
	argocd app create argo-workflows \
		--repo $(REMOTE_REPO) --revision $(REVISION) \
		--path charts/argo-workflows \
		--dest-server https://kubernetes.default.svc \
		--dest-namespace default
	argocd app sync argo-workflows

minio:
	argocd app create minio \
		--repo $(REMOTE_REPO) --revision $(REVISION) \
		--path charts/minio \
		--dest-server https://kubernetes.default.svc \
		--dest-namespace default
	argocd app sync minio
