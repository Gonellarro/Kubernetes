#/bin/bash

#Esborram tots els clusters que tenim
kind delete clusters --all
#Cream el cluster de Kubernetes amb la declaració de la pràctica 3
kind create cluster --name vich-servera --config cluster.yaml

echo "Cream el Ingress Controller..."
#Cream l'ingress-controler
#Definició incorrecta
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.0/deploy/static/provider/cloud/deploy.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
sleep 10

echo "Etiquetam els nodes..."
#Etiquetam els nodes amb la posicio front a 2 nodes i back a un node
kubectl label nodes vich-servera-worker tier=front
kubectl label nodes vich-servera-worker2 tier=front
kubectl label nodes vich-servera-worker3 tier=back

echo "Cream ens namespaces..."
#Cream els namespeces necessaris: frontend i backend
kubectl create namespace frontend
kubectl create namespace backend

echo "Cream els volums..."
#Cream els volumes i volume claims
kubectl apply -f pv.yaml
kubectl apply -f databasepvc.yaml

echo "Cream els configmaps i secrets..."
#Cream els configmaps i secrets
kubectl apply -f configmapwebserver.yaml
kubectl apply -f secretdb.yaml

echo "Cream les repliques i els deployments..."
#Cream la replica del servidor web
kubectl apply -f replicaweb.yaml

#Cream la replica del servidor de continguts
kubectl apply -f replicacontentserver.yaml

#Cream el deployment de la bd
kubectl apply -f deploymentbd.yaml

echo "Esperam a que se crein els pods..."
sleep 30
kubectl get pods -n=frontend
kubectl get pods -n=backend

echo "Cream els serveis..."
#Cream els services per a tots els pods
kubectl apply -f servicecontent.yaml
kubectl apply -f servicedb.yaml
kubectl apply -f serviceweb.yaml

#Eliminam la validació del web hook configuration de l'ingres nginx
#kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

echo "Cream l'ingress web..."
#Cream els ingress pels serveis de web i content
kubectl apply -f ingressweb.yaml

