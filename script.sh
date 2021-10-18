#!/bin/bash

case $1 in

wordpress) echo $(minikube service wordpress --url);;

grafana) kubectl port-forward -n monitoring $(kubectl get pods -n monitoring|grep grafana|awk '{print $1}') 3000 ;;

argo) kubectl port-forward svc/argocd-server -n argocd 8080:443 ;;

argo-passwd) echo "A senha do ArgoCD e: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)" ;;

esac
