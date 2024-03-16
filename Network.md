# Network
Recordem que els pods es generen dins uns nodes i això fa que els pods se puguin connectar amb altres pods. Per això tenim les següents regles (n'hi ha més però aquestes són les bàsiques):

- Tot pod té una IP
- Tot pod s'hauria de poder connectar a cada pod dins del mateix node
- Cada pod s'hauria de poder connectar a una altre pod en un node diferent sense emprar NAT

Per a tot això s'encarrega el CNI: Container Network Interface. K8s s'encarrega de gestionar aquesta connectivitat. Això és una API per gestionar recursos. Per tant, si vulguessim podríem poder canviar de gestor de xarxes.




