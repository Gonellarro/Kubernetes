# Exercici3 - Resolucio

0. El primer que hem de fer és eliminar el clúster inicial i crear-ne un de nou amb la definició que ens ha proporcionat el professor. Per això farem:

```bash:
kind delete clusters --all
kind create cluster --name practiques --config cluster.yaml
```
1. Feim el primer exercici. Per això hem de generar el nou namespace que se dirà ns-practica3, i llavors llançar el pod1, tal i com està a la definició que hem creat al fitxer pod1.yaml:

```bash:
kubectl apply -f namespace.yaml
kubectl apply -f pod1.yaml
```

Si ha anat tot bé, podem veure que no acaba bé el pod, però el log és correcte:

```bash:
kubectl get pods -n=ns-practica3
```
>NAME          READY   STATUS             RESTARTS     AGE   
practica3-1   0/1     CrashLoopBackOff   1 (6s ago)   12s  

Veurem que ens dóna un CrashLoopBackOff. No he aconseguit que acabi millor, però el resultat pareix que és el correcte:

```bash:
kubectl logs practica3-1 --all-containers -n=ns-practica3
```
Ens surt clarament:   
>Me gusta Kubernetes

2. Feim el segon exercici. Per això hem de crear el configMap amb el fitxer configMap.yaml i llavors llançar el pod2.yaml

```bash:
kubectl apply -f configMap.yaml
kubectl apply -f pod2.yaml 
```
Novament ens dóna error si feim un get pods, però correcte si miram el log:

```bash:
kubectl logs practica3-2 --all-containers -n=ns-practica3
```
> Me gusta Kubernetes  
Tararior tarararo Lorem ipsum dolor sit amet Ut enim ad minim veniam

3. En terecer exercici també hem de crear primer el secret, aplicant la definició de secret.yaml i llavors el pod3.yaml:

```bash:
kubectl apply -f secret.yaml
kubectl apply -f pod3.yaml 
```
Ens torna a donar error el get pod, però bé el log:

```bash:
kubectl logs practica3-3 --all-containers -n=ns-practica3
```
>SOCELMILLOR

4. El quart exercici hem de crear el PV general per tot el clúster i llavors reclamar els 50MB. Un cop fet, seguirem amb el pod4.yaml:

```bash:
kubectl apply -f pv500.yaml
kubectl apply -f pvc.yaml
kubectl apply -f pod4.yaml 
```
En aquest cas, no soc capaç de veure si el resultat és correcte, ja que no arribo a veure cap fitxer a /tmp del servidor.



