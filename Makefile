
ARGOCD_PORT := 8080
CLUSTER_NAME := docker-desktop ## $(shell kubectl config current-context | cat)
ENDPOINTS := 172.24.0.2:6443

default:
	@echo "REGISTRY_BASE ------------------> ${REGISTRY_URL}"


deploy-argocd:
	kubectl create namespace argocd
	kubectl apply -n argocd -f argocd/argo-deployment.yaml
	kubectl get pods -n argocd

install-argocd-cli:
	curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
	sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
	rm argocd-linux-amd64
	argocd version

expose-argocd:
	@echo "argocd initial password is:\n---------------------"
	kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
	@echo "\n---------------------"
	kubectl port-forward svc/argocd-server -n argocd ${ARGOCD_PORT}:443

endpoints:
	kubectl get -n default endpoints

argocd-add-cluster:
	@echo "Adding cluster ${CLUSTER_NAME} to argocd"
	argocd cluster add ${CLUSTER_NAME}



