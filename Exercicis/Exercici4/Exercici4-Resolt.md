# Exercici 4 - Resolució

1. En aquest exerci el que volem fer és crear una web que retorni un echo  de la sol·licitud enviada pel client.Per això existeix la imatge [ealen/echo-server:latest](https://github.com/Ealenn/Echo-Server) cumpleix amb això (*An echo server is a server that replicates the request sent by the client and sends it back.*).

Per dur-ho a terme el que farem serà:
- Crear un deployment amb 2 rèplicques d'aquesta imatge
- Crear un service que es gestioni internament com es reparteix el servei als pods creats pel deployment
- Crear un ingress que ens traspassi la sol·licitud externa i la atorgi al nostre servei
- Crear un Ingress Controler que gestioni el nostre Ingress.

![Imatge procés de gestió d un servei amb Ingress i Service](https://kubernetes.io/docs/images/ingress.svg)

## Deployment
El fitxer de definicions del deployment serà:

```yaml:
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echoserver
  namespace: ns-practica4
spec:
  replicas: 2
  selector:
    matchLabels:
      app: echoserver
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: echoserver
    spec:
      containers:
      - image: ealen/echo-server:latest
        imagePullPolicy: Always
        name: echoserver
        ports:
        - containerPort: 80
          protocol: TCP
```

L'executam mitjançant:

```bash:
kubectl apply -f deployment.yaml
```

Això ens crea 2 Pods de la imatge de echo-server.

>Nota: No està explicat (crec) el rollingUpdate i els seus atributs

## Service
