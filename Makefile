MINIKUBE = /usr/bin/env minikube
KUSTOMIZE = /usr/bin/env kustomize
KUBECTL = /usr/bin/env kubectl

minikube:
	$(MINIKUBE) start \
	--kubernetes-version=v1.18.15 \
	--vm-driver=virtualbox \
	--cpus=2 \
	--memory=4g \
	--bootstrapper=kubeadm \
	--extra-config=kubelet.authentication-token-webhook=true \
	--extra-config=kubelet.authorization-mode=Webhook \
	--extra-config=scheduler.address=0.0.0.0 \
	--extra-config=controller-manager.address=0.0.0.0
	minikube addons enable ingress
step-1:
	$(KUSTOMIZE) build step-1 | $(KUBECTL) apply -f -

step-2:
	kubectl create namespace monitoring 2>/dev/null; true
	$(KUSTOMIZE) build step-1 | $(KUBECTL) apply -f -

step-3: 
	kubectl create namespace argocd 2>/dev/null; true
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

erase:
	$(KUSTOMIZE) build step-1 | $(KUBECTL) delete -f - 2>/dev/null; true
	$(KUSTOMIZE) build step-2 | $(KUBECTL) delete -f - 2>/dev/null; true
	kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 2>/dev/null; true
	kubectl delete namespace monitoring 2>/dev/null; true
	kubectl delete namespace argocd 2>/dev/null; true


.PHONY: minikube step-1 step-2 step-3 erase
