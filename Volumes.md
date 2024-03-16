# Volumes
És on s'emmagatzemen les dades. Aquests volumens són visibles per tots els pods del mateix namespace, és a dir, tots el poden consultar/escriure si les polítiques els hi permeten.

N'hi ha de dos tipus:

- Persistent Volume
- Persisten Volume Claim

## Persistent Volume
Són volumens persistents d'un disc s'empri o no per Kubernetes. Se defineixen coses com:
- Tamany
- Cóm s'accedeix
- Què es fa amb ell quan ha deixat de ser emprat

Exemple:
```yaml:
apiVersion: v1
kind: PersistentVolume
metadata:
	name: volume001-pv
spec:
	capacity:
		storage: 1Gi
	accessModes:
	- ReadWriteOnce
	- ReadOnlyMany
	persistentVolumeReclaimPolicy: Retain
	hostPath:
		path: /work
```

- Capacity: Indica la capacitat que ha de tenir el volumen
- accessModes: Indica quins modes d'accés té el volumen:
	- ReadWriteOnce: Només pot escriure un a la vegada
	- ReadOnlyMany: Poden llegir tots a la vegada
- persistentVolumeReclaimPolicy: Política de retenció de les dades. En aquest cas està posat que es mantinguin. Podríem posar que s'esborrasin o es fes al cap d'un temps,...
- hostPath: És la ruta al pod on ha de muntar el disc

## Persisten Volume Claim
És el que un pod pot sol·licitar d'espai. És la definició del que rebrà d'espai, un pod. Pot ser tinguem un PV de 500GB, però el PVC ser d'1GB, perquè és el que realment necessita el pod per funcionar. Per tant, el tamany del disc que rebrà aquest pod serà 1GB, independentment del tamany del volum per davall.

Exemple:
```yaml:
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
	name: volume001-pvc
spec:
	resources:
		requests:
			storage: 1Gi
	accessModes:
		- ReadWriteOnce
	storageClassName: ""
```

## Maneig

Per veure els volums que tenim, emprarem les comandes:
```bash:
kubectl get pv
kubectl get pvc
```

Exemple en un deployment:
```yaml:
apiVersion: apps/v1
kind: Deployment
metadata:
	name: nginx-deployment
spec:
	replicas: 1
	selector:
		matchLabels:
			app: nginx
	template:
		metadata:
			labels:
				app: nginx
		spec:
			containers:
			- name: nginx
			  image: nginx
			  ports:
			  - name: http
			    containerPort: 80
			  volumeMounts:
			  - name: staticFiles
			    mountPath: /usr/share/nginx/html
		  - name: quarkus
		    image: yo/randomIndexQuarkus:1.0.0-SNAPSHOT
		    volumeMounts:
		    - name: staticFiles
		      mountPath: /generatedFiles
		    volumes:
		    - name: staticFiles
		      persistentVolumeClaim:
			      claimName: pvc
```

