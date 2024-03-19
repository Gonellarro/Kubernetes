#/bin/bash

#Cream el cluste de cubernetes amb la declaració de la pràctica 3
kind create cluster --name vich-servera --config cluster.yaml

#Etiquetam els nodes amb la posicio front a 2 nodes i back a un node
kubectl label nodes vich-servera-worker tier=front
kubectl label nodes vich-servera-worker2 tier=front
kubectl label nodes vich-servera-worker3 tier=back

#Cream els namespeces necessaris: frontend i backend
kubectl create namespace frontend
kubectl create namespace backend

#Cream els volumes i volume claims
kubectl apply -f pv.yaml
kubectl apply -f databasepvc.yaml

#Cream els configmaps i secrets
kubectl apply -f configmapwebserver.yaml
kubectl apply -f secretdb.yaml

#Cream els services per a tots els pods
kubectl apply -f servicecontent.yaml
kubectl apply -f servicedb.yaml
kubectl apply -f serviceweb.yaml

#Cream l'ingress-controler
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.0/deploy/static/provider/cloud/deploy.yaml

#Cream els ingress pels serveis de web i content
kubectl apply -f ingress.yaml

#Cream el deployment de la bd
kubectl apply -f deploymentbd.yaml

#Cream la replica del servidor web
kubectl apply -f replicaweb.yaml

#Cream la replica del servidor de continguts
kubectl apply -f replicacontentserver.yaml

