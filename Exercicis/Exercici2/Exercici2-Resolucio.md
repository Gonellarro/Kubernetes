# Exercici 2 - Resolt

## Introducció

Revisam la instal·lació que tenim feta de l’exercici anterior. Miram primer quins nodes tenim:


Com podem veure, ens ha creat els 3 workers i el control plane. Anem a començar, sabent d’on partim, amb la pràctica 2.

### Etiquetar els nodes

Els nodes han de tenir les següents labels:	

- worker1: size=Large
- worker2: size=Medium
- worker3: size=Small

Emprarem la comanda del tipus:

```bash
kubectl label nodes <node> <key>=<map>
```
La posam en marxa en el nostre exercici:

```bash
kubectl label nodes exercici1-worker size=Large
kubectl label nodes exercici1-worker2 size=Medium
kubectl label nodes exercici1-worker3 size=Small
```

Revisam que tinguin les etiquetes correctes amb la comanda:

```bash
kubectl get nodes --show-labels
```

![Workers1](../../imgs/workers1.png)

## Instalación 1 

>Desplegar un pod con varias labels que tiene 2 contenedores (web y cache).
>Adicionalmente , tiene como requisitos un mínimo de 100 megabytes de RAM. Debe desplegar únicamente en el worker3. Debe tener configurada una estrategia de control para que se reinicie en caso de problemas. Debe hacerse en un namespace con nombre practica2inst1.

Cream primerament el namespace per tenir-lo creat per endavant, amb la comanda:

```bash
kubectl create namespace practica2inst1
```

Amb la comanda següent revisam els namespaces creats:

```bash
kubectl get namespaces
```

![namespaces1](../../imgs/namespaces1.png)

Un cop tenim el namespace creat, crearem la definició del nostre pod al yaml:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: practica2inst1
  namespace: practica2inst1
spec:
  containers:
  - name: nginx-server
    image: nginx
    ports:
      - containerPort: 80
    resources:
      requests:
        memory: "100Mi"
  - name: cache
    image: redis
    resources:
      requests:
        memory: "100Mi"
  nodeSelector:
    size: Small
```


**Nota:** No hem sabut com fer el reinici en cas de problemes. Es fa mitjançant un liveprobe.

Aplicam el yaml amb la comanda:

```bash
kubectl apply -f pod2.yml
```
Llistam els pods que corren al node worker3 amb la comanda:

```bash
kubectl get pods --field-selector spec.nodeName=exercici1-worker3 --namespace practica2inst1
```

**Nota:** No és aquesta la comanda a emprar. Revisar!

## Instalación 2

>Despliegue de una aplicación web con 2 réplicas del mismo servidor web. Debe hacerse en un namespace con nombre practica2inst2.
(contenido clase 3) Adicionalmente, deben desplegarse en los nodos de tamaño Medium o Large y deben tener unos healthchecks que controlen el correcto funcionamiento. Los pods no pueden ejecutarse en el mismo nodo. Una vez esté funcionando añadir una réplica más y mostrar el estado del despliegue.


a) Anem primerament a crear el nou namespace per aquesta segona pràctica amb la comanda:

```bash:
kubectl create namespace practica2inst2
```

Un cop tenim el namespace creat, anem a crear la definició de la réplica al fitxer yaml:

```yaml:
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: practica2inst2
  namespace: practica2inst2
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webserver
  template:
    metadata:
      labels:
        app: webserver
    spec:
      containers:
      - name: nginx-server
        image: nginx
```

Empram la comanda per posar en marxa les rèpliques:

```bash:
kubectl apply -f replica.yml --namespace=practica2inst2
```

Veim que ens crea la rèplica:

![Rèplica](../../imgs/replica.png)

I tenim els pods creats:

![podsReplica](../../imgs/podsreplica.png)

Empram la comanda següent per veure a quin node està cada pod:

```bash:
kubectl describe pod practica2inst2-99jcb -n=practica2inst2
```
![describePod](../../imgs/describePod.png)

Podem veure que el primer s’ha creat al node worker i el segón, ho ha fet al node worker2. Com no hem indicat a quins nodes s’havien d’allotjar, ho han fet al que l’scheduler ha cregut més convenient.

b) Anem a canviar el nostre yml, per tal de fer un deployment dels nostres pods amb les condicions que se’ns demana:
- Que tinguin Healthcheck que controli el funcionament correcte dels pods
- S’han de desplegar als nodes Medium o Large
- No es poden executar al mateix node

Per mirar de que tenguin un Healthcheck emprarem un LiveProbe  afegint el següent:

 ```yaml: 
  spec:
      containers:
      - name: nginx-server
        image: nginx
        ports:
          - containerPort: 80
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 5
```

Per mirar que només s’executin als nodes Large i Medium afegirem el següent codi:

```yaml:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                - key: size
                  operator: In
                  values:
                  - Large
                  - Medium
```

Finalment, per fer que no s’executin al mateix node, emprarem la característica AntiAffinity:

```yaml:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - webserver
            topologyKey: "kubernetes.io/hostname"
```


El fitxer resultant és el següent:

```yaml:
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: practica2inst2
  namespace: practica2inst2
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webserver
  template:
    metadata:
      labels:
        app: webserver
    spec:
      containers:
      - name: nginx-server
        image: nginx
        ports:
          - containerPort: 80
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 5
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                - key: size
                  operator: In
                  values:
                  - Large
                  - Medium
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - webserver
            topologyKey: "kubernetes.io/hostname"
```

Executam la comanda següent per actualitzar la rèplica:

```bash:
kubectl apply -f replica2.yml --namespace=practica2inst2
```
I confirmam que els pods estan correctes, amb la comanda:

```bash:
kubectl get pods -n=practica2inst2
```
![getPods](../../imgs/getpodsN.png)

Veurem ara si s’ha canviat la distribució de cada pod en funció de l’afinitat amb la comanda:

```bash:
kubectl describe pod practica2inst2-99jcb -n=practica2inst2
```
![podWorker](../../imgs/podWorker.png)

Recordam que havíem assignat les etiquetes als nodes i podem veure que han anat als nodes que toca: Large o Medium. No han canviat de node perquè ja havien caigut a nodes compatibles o afins.

![podWorkerSize](../../imgs/workerPodSize.png)

c) Miram d’augmentar en un la rèplica però ja podem preveure el resultat. Si no permetem que hi hagi més d’un pod a un node, i només hi ha 2 nodes possibles, llavors és segur que aquest pod no es pugui ubicar i quedi pendent fins que es creï un node que sí ho permeti.

![canviReplica](../../imgs/canviReplica.png)

I les tornam a llançar amb la comanda:

```bash:
kubectl apply -f replica3.yml --namespace=practica2inst2
```
Miram quants pods tenim en aquest moment i ens tocaríen sortir 3, però un amb problemes, amb la comanda:

```bash:
kubectl get pods -n=practica2inst2
```
![podsReplica3](../../imgs/podsReplica3.png)

Efectivament, veim que s’ha creat el pod practica2inst2-mjrvp, però ha quedat en pending per mor de que no és capaç de trobar un node que el pugui albergar.

## Instalación 3

>Despliegue de una aplicación web con 2 réplicas del mismo servidor web. Debe hacerse en un namespace con nombre practica2inst3.(contenido clase 3) Deben tener unos healthchecks que controlen el correcto funcionamiento. Los pods no pueden ejecutarse en el mismo nodo (se puede reaprovechar la instalación 2 si se quiere). Adicionalmente debe desplegarse una aplicación (cache) y deben tener unos healthchecks que controlen el correcto funcionamiento. Los pods no pueden ejecutarse en el mismo nodo. Cada pod web debe correr en un nodo donde haya un pod cache.

a) En aquest cas farem el mateix que en l’exercici 2.2, però al namespace practica2inst3:

```bash:
kubectl create namespace practica2inst3
kubectl get namespaces
```
![getNamespaces](../../imgs/getNamespaces.png)

Cream el fitxer yaml amb la descripció de la rèplica i l’executam amb la comanda:

```bash:
kubectl apply -f replica4.yml -n=practica2inst3
```

El contingut del fitxer és el següent:

```yaml:
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: practica2inst3
  namespace: practica2inst3
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webserver
  template:
    metadata:
      labels:
        app: webserver
    spec:
      containers:
      - name: nginx-server
        image: nginx
        ports:
          - containerPort: 80
```

Mostram els pods creats, amb la comanda:

```bash:
kubectl get pods -n=practica2inst3
```
b) En aquest punt me surgeixen dubtes de exactament què hem de fer, ja que l’enunciat és interpretable de diferents maneres. Me pos en el cas més elaborat:
- S’han  de crear rèpliques web i cache de 2 pods. 
- Els pods d’ambdues rèpliques no poden executar-se al mateix node.
- Els pods d’ambdues rèpliques han de tenir Healthchecks 
- Els pods web no poden anar a nodes que no hi hagin pods cache.

	Amb aquestes premises, elaboram els següents fitxers yaml:

**replicaweb.yaml**
```bash:
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: practica2inst3web
  namespace: practica2inst3
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webserver
  template:
    metadata:
      labels:
        app: webserver
    spec:
      containers:
      - name: nginx-server
        image: nginx
        ports:
          - containerPort: 80
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 5
      affinity:
        podAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchExpressions:
                - key: app
                  operator: In
                  values:
                  - cache
              topologyKey: "kubernetes.io/hostname"
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - webserver
            topologyKey: "kubernetes.io/hostname"
```
**replicache.yaml**

```yaml:
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: practica2inst3cache
  namespace: practica2inst3
spec:
  replicas: 2
  selector:
    matchLabels:
      app: cache
  template:
    metadata:
      labels:
        app: cache
    spec:
      containers:
      - name: cache
        image: redis
        ports:
          - name: http
            containerPort: 5601
            protocol: TCP
        livenessProbe:
          exec:
            command:
            - sh
            - -c
            - redis-cli -a {{ .Values.app.env.REDIS_PASSWORD }} ping
          initialDelaySeconds: 10
          timeoutSeconds: 5
```
Posam en marxa els dos yamls. Primer el de la cache i llavors el del web:

```bash:
kubectl apply -f replicaCache.yml -n=practica2inst3
kubectl get pods -n=practica2inst3
```
![webCache](../../imgs/webcache.png)

```bash:
kubectl apply -f replicaWeb.yml -n=practica2inst3
kubectl get pods -n=practica2inst3
```
![webCache2](../../imgs/webcache2.png)

Podem veure com:
S’han creat els 4 pods: 2 de web i 2 de cache
Els 2 de cache estan funcionant
Només 1 de web ho està. L’altre està pending

Anem a veure perquè el web està pending amb la comanda: 

```bash:
kubectl describe pod practica2inst3web-z2kjl -n=practica2inst3
```
![warning](../../imgs/warning.png)

Pel que indica el warning, pareix que hi ha 2 nodes on no poden conectar per una Anti-Affinity, cosa que no entenem gaire, ja que aquests pods només tenen Anti-Affinity si ja hi ha un altre pod igual al node. No acabam d’entendre bé el motiu del warning.

No pareix que no se pugui posar el pod que no funciona damunt del worker2. Les definicions que hem fet al fitxers yaml no exclouen posar un pod web damunt el node worker2, ni té una Anti-Affinity d’aquest node. 

Tornar a llançar la rèplica no ho ha solucionat. Ho deixam així després de donar-li moltes voltes i no trobar una explicació. 

























