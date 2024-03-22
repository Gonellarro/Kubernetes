#Instal·lam el servei de Helm
sudo bash instalacio.sh

#Descarregam el chart Nginx chart de Bitnami
helm install exercici2 oci://registry-1.docker.io/bitnamicharts/nginx

#Mostram la release i l'estat dels pods
helm list
kubectl get pods
echo "--------------------------------------------------------------------------"
echo "Canviam la imatge amb una versió incorrecta"
#Canviar la imatge amb dades errònies
#helm show values oci://registry-1.docker.io/bitnamicharts/nginx > valors.yaml
helm upgrade --install -f valorsErronis.yaml exercici2 oci://registry-1.docker.io/bitnamicharts/nginx
echo "--------------------------------------------------------------------------"

#Mostram la release i l'estat dels pods erronis
helm list
kubectl get pods
echo "--------------------------------------------------------------------------"

#Feim rollback a la revisió prèvia
helm rollback exercici2 
echo "--------------------------------------------------------------------------"

#Mostram la release i l'estat dels pods novament restaurats
helm list
kubectl get pods

#Eliminam la realease
sleep 2
helm uninstall exercici2
