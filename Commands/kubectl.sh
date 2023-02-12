#AKS management
az aks get-credentials --name $env:TF_VAR_AKS_CLUSTER --resource-group $env:TF_VAR_AKS_RESOURCE_GROUP
az aks install-cli  #to install kubectl if not installed


kubectl get nodes
kubectl apply -f workload.yaml
kubectl apply -f api.yaml
kubectl get pods -o wide
kubectl describe pod <failed pod name>
kubectl get nodes -l="kubernetes.azure.com/mode=user","kubernetes.io/os=linux" -w
kubectl scale --replicas=40 deploy/workload
kubectl delete deploy/workload