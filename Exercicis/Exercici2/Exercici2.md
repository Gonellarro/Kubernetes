# Exercici 2
Se debe partir de un cluster de kubernetes con 3 nodos worker (realizado en práctica 1).

(contenido clase 3)  
Los nodos deben tener las siguientes labels:  
- worker1: size=Large
- worker2: size=Medium
- worker3: size=Small

Se deben realizar 3 instalaciones con las siguientes características:

- Instalación 1: Desplegar un pod con varias labels que tiene con 2 contenedores (web y cache).

(contenido clase 3)  
Adicionalmente , tiene como requisitos un mínimo de 100 megabytes de ram. Debe desplegar únicamente en el worker3. Debe tener configurado una estrategia de control para que se reinicie en caso de problemas. Debe hacerse en un namespace con nombre practica2inst1.

- Instalación 2: Despliegue de una aplicación web con 2 replicas del mismo servidor web. Debe hacerse en un namespace con nombre practica2inst2.

(contenido clase 3)  
Adicionalmente, debe desplegarse en los nodos de tamaño Medium o Large y deben tener unos healthchecks que controlen el correcto funcionamiento. Los pods no pueden ejecutarse en el mismo nodo. Una vez esté funcionando añadir una réplica más y mostrar el estado del despliegue.

- Instalación 3: Despliegue de una aplicación web con 2 replicas del mismo servidor web. Debe hacerse en un namespace con nombre practica2inst3.

(contenido clase 3)  
Deben tener unos healthchecks que controlen el correcto funcionamiento. Los pods no pueden ejecutarse en el mismo nodo (se puede reaprovechar la instalación 2 si se quiere). Adicionalmente debe desplegarse una aplicación (cache) y deben tener unos healthchecks que controlen el correcto funcionamiento. Los pods no pueden ejecutarse en el mismo nodo. 

Cada pod web deber correr en un nodo donde haya un pod cache.

Datos adicionales:  
- imagen servidor web: nginx
- imagen servidor cache: redis.
