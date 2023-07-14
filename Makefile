ARGOCD_PORT := 8181
CLUSTER_NAME := $(shell kubectl config current-context | cat)
ARGOCD_PASSWORD := $(shell kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d | cat)

default:
	@echo "kube control current context------------------> ${CLUSTER_NAME}"
	@echo "ARGOCD exposed port---------------------------> ${ARGOCD_PORT}"
	@echo "ARGOCD initial password-----------------------> ${ARGOCD_PASSWORD}"

create-cluster:
	kind create cluster --config cluster.yaml
	
deploy-argocd:
	kubectl create namespace argocd
	kubectl apply -n argocd -f argocd/argo-deployment.yaml
	kubectl get all -n argocd

install-argocd-cli:
	curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
	sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
	rm argocd-linux-amd64
	argocd version

expose-argocd:
	@echo "argocd initial password is:\n---------------------${ARGO_PASSWORD}""
	@echo "\n---------------------"
	kubectl port-forward svc/argocd-server -n argocd ${ARGOCD_PORT}:443

endpoints:
	kubectl get -n default endpoints

argocd-add-cluster: expose-argocd
	argocd login localhost:${ARGOCD_PORT} 
	@echo "Adding cluster ${CLUSTER_NAME} to argocd"
	argocd cluster add ${CLUSTER_NAME}

argocd-patch-nodeport:
	kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'  

argocd-add-app:
	@echo "listing argocd clusters:\n"
	argocd cluster list 
	@echo "adding app to argocd"
	argocd app create nginx-app --repo https://github.com/danilomr12/kubernetes_learning.git --path ./argocd/argo-repo/ --dest-server https://172.21.0.2:6443 --dest-namespace default