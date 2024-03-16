# Exercici 3
1.- Crear un despliegue de un pod que imprima por consola un mensaje que reciba por argumento (por ejemplo: "Me gusta Kubernetes").


2- Crear un despliegue de un pod que imprima por consola 2 mensajes que obtenga desde una configuración external a la definición del pod Los mensajes son:
 "Me gusta Kubernetes"
 "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
 Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
 Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." (contiene saltos de linea).

3.- Crear un pod que lea una APIKEY ofuscada en un secreto y la imprima por consola. La APIKEY será la siguiente: "ESTOESUNAAPIKEY".

4.- Crear un pod que monté un disco persistente (50MB es más que suficiente), y que escriba un texto a elegir en el fichero "hola.txt".


Todo debe crearse en el namespace practica3

Imagen a usar: alpine (o ubuntu, debian, ...)

Recomendación de configuración de KIND para poder montar volúmenes y futuras prácticas.

Crear un cluster con KIND con las siguientes características:

kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 18080
    protocol: TCP
  - containerPort: 443
    hostPort: 18443
    protocol: TCP
- role: worker
  extraMounts:
  - hostPath: /tmp/worker1
    containerPath: /work
- role: worker
  extraMounts:
  - hostPath: /tmp/worker2
    containerPath: /work
- role: worker
  extraMounts:
  - hostPath: /tmp/worker3
    containerPath: /work

Con esta configuración ya podremos hacer todas las prácticas adicionales e incluso la práctica final. Incluye la siguiente parte:

- Ingress : para acceder desde fuera al cluster de K8s y poder acceder a los servicios que desplegamos
- Volúmenes: permite montar discos en K8s que al final serán un path en vuestro entorno local. Requiere que se de permisos a los folders (/tmp/worker1 /tmp/worker2 y /tmp/worker3 en Docker Desktop).
