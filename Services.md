# Services
Kubernetes gestiona el desplegament de contenidors per donar serveis.

Entenem per service a Kubernetes com una definició d'un servei que pot esser emprat per la resta de pods. 

Els services permeten connectar els diferents components de K8s tant internament com externament al clúster de K8s amb altres aplicacions o usuaris.

P.e. un balancejador de càrrega davant dels servidors que rep les peticions dels usuaris. El que es fa és que aquestes peticions vagin a un service i sigui aquest el que les distribueixi.

Se solen emprar per poder accedir als pods generats per una definció de deployments, replicasets o pods nominals.

**El correcte és que quan un pod vol accedir a un altre, aquest ho faci a través d'un service**

I hem vist que els services poden esser tant interns com externs. Això vol dir que és possible que un service ens tregui els pods fora de Kubernetes. P.e. quan volem que els pods accedeixin a una BD externa. El que farem serà dirigir els pods a un service i que aquest s'encarregui de gestionar la connexió amb la BD externa (fora de l'abast del curs).

## Avantatges:
- **Un únic punt d'accés a una aplicació.** No ens hem de referir a una IP que pot canviar. No. Ens dirgim al service que és un sol punt conegut pels pods. I
-  **Descobriment automàtic de nous pods:** el service, quan es crea, reconeix als pods del clúster, inclús si es creen de nous i els posa a la llista de possibles clients del servei.
- **Abstreuen l'accés a serveis externs al clúster de K8s**
- **Configuració senzilla**

## Tipus
Hi ha varis tipus de serveis que hem de conèixer:

- **Clúster IP:** És el més emprat. Crea una IP interna del clúster per esser accedit INTERNAMENT dins del clúster de K8s. Això vol dir que internament es crea un servei de tipus "Clúster IP" qué defineix un servei que ens abstreu de quants de pods hi ha per darrera, fent un balanceig de round robin i envia les peticions als diferents pods. És el que s'empra per defecte.
- **Node port:** Exposa el service a cada IP del node en un port estàtic (el NodePort). Automàticament es crea un Service ClusterIp, al qual s'enruta el NodePort del Service. Per entendre-ho, si tenim 3 workers nodes, cada worker node tendria un port on el servei és accesible a nivell de màquines. Obri ports on podrien atacar els usuaris des de fora del clúster de k8s. Però és difícil d'accedir, ja que han de saber aquests ports, les IPs dels wns, etc... No l'emprarem.
- **Load Balancer:** Emprat per cloud provaiders per a què se pugui exposar el servei al núvol.  El veurem poc.
- External Name: Mapeja un servei fora de k8s. No l'emprarem gens

## Definfició
```yaml:
apiVersion: v1
kind: Service
metadata:
	name: mi-servicio
spec:
	selector:
		app.kubernetes.io/name: nginx
	ports:
		- protocol: TCP
		  port: 8080
		  targetPort: 80
```

Ens fixam que li estam indicant amb el selector que ha de tenir el compte els pods que tenguin com a labels **nginx**. És important definir-ho perquè sino no els tindrà com a pods que poden accedir al servei.

Un service pot tenir varis ports definits. No només ha de tenir 1. Després aquests ports es redirigeixen als ports dels pods, amb la clau targetPort. Per tant, el port fa referència al port que té exposat el service i el targetPort és el port en el que està escoltant el pod.

Exemple:
```yaml:
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app.kubernetes.io/name: MyApp
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 9376
    - name: https
      protocol: TCP
      port: 443
      targetPort: 9377
```

>**Nota:**
Normalment els noms en Kubernetes només poden anar en caràcters alfanumèrics en minúscules  més el  caràcter -. Els **noms** dels ports també i han de començar i acabar amb un caràcter alfanumèric (no  pot esser el "-").   

For example, the names `123-abc` and `web` are valid, but `123_abc` and `-web` are not.

Fixem-nos que no hem definiit el tipus de service és. Si no ho feim, per defecte cull el cústerIp.

Exemple de service amb pods:

Definim el pod
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app.kubernetes.io/name: proxy
spec:
  containers:
  - name: nginx
    image: nginx:stable
    ports:
      - containerPort: 80
        name: http-web-svc
```

Definim el service
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app.kubernetes.io/name: proxy
  ports:
  - name: name-of-service-port
    protocol: TCP
    port: 80
    targetPort: http-web-svc
```

Ens fixam que el pod es nom proxy (definit a la label app.kubernetes.io/name)  i que el service dónarà servei a aquelles que es diguin proxy igualment, perquè ho té definit al selector de labels.
 
 També podem veure que els ports poden tenir un nom. Això és interessant perque el service no ha de saber quin és el nombre del port, sino el nom que té. D'aquesta forma podem canviar el nombre dins el pod i el service no s'entem. Seguiria funcionant correctament.
 


Fonts: 
[Documentació Kubernetes](https://kubernetes.io/docs/concepts/services-networking/service/)

