# Deployment Challenge

## Step 1 - Create the initial deployment

I personally prefer using the declarative method, the command used in this case was: 

`kubectl create deployment nginx-deployment --image=nginx:1.26.2 --replicas=3 --namespace=cloudstation --port=80 --dry-run=client -oyaml > nginx-deployment.yaml`

Note: The namespace cloudstation was created prior to the execution of above command. Using command: `kubectl create namespace cloudstation`

Then in order to deploy your Deployment, use the following commnand:

`kubectl apply -f nginx-deployment.yaml`

## Step 2 - Update the Image, using Rolling Update

In order to trigger the update of the image of the containers, you could use the following command:

`kubectl set image -n cloudstation deployment/nginx-deployment nginx=nginx:1.27.1`

Here what was trying to achieve, was updating nginx from 1.26.2 to 1.27.1 version

### Watch

In order to verify the reliability provided by kubernetes, while running the update, a watch command was executed to verify the creation and removal of the pods during the Rolling Update.

Command: `kubectl get pods -n cloudstation --watch`

Output: 
```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-64cf9b4469-94kk8   1/1     Running   0          4s
nginx-deployment-64cf9b4469-gxl9r   1/1     Running   0          4s
nginx-deployment-64cf9b4469-pwcrz   1/1     Running   0          4s
nginx-deployment-75fc4dddc5-rxhqs   0/1     Pending   0          0s
nginx-deployment-75fc4dddc5-rxhqs   0/1     Pending   0          0s
nginx-deployment-75fc4dddc5-rxhqs   0/1     ContainerCreating   0          0s
nginx-deployment-75fc4dddc5-rxhqs   1/1     Running             0          3s
nginx-deployment-64cf9b4469-pwcrz   1/1     Terminating         0          3m7s
nginx-deployment-75fc4dddc5-wwhbr   0/1     Pending             0          0s
nginx-deployment-75fc4dddc5-wwhbr   0/1     Pending             0          0s
nginx-deployment-75fc4dddc5-wwhbr   0/1     ContainerCreating   0          0s
nginx-deployment-64cf9b4469-pwcrz   0/1     Completed           0          3m7s
nginx-deployment-75fc4dddc5-wwhbr   1/1     Running             0          1s
nginx-deployment-64cf9b4469-pwcrz   0/1     Completed           0          3m8s
nginx-deployment-64cf9b4469-pwcrz   0/1     Completed           0          3m8s
nginx-deployment-64cf9b4469-gxl9r   1/1     Terminating         0          3m8s
nginx-deployment-75fc4dddc5-lvlpj   0/1     Pending             0          0s
nginx-deployment-75fc4dddc5-lvlpj   0/1     Pending             0          0s
nginx-deployment-75fc4dddc5-lvlpj   0/1     ContainerCreating   0          0s
nginx-deployment-64cf9b4469-gxl9r   0/1     Completed           0          3m8s
nginx-deployment-75fc4dddc5-lvlpj   1/1     Running             0          1s
nginx-deployment-64cf9b4469-gxl9r   0/1     Completed           0          3m9s
nginx-deployment-64cf9b4469-gxl9r   0/1     Completed           0          3m9s
nginx-deployment-64cf9b4469-94kk8   1/1     Terminating         0          3m9s
nginx-deployment-64cf9b4469-94kk8   0/1     Completed           0          3m9s
nginx-deployment-64cf9b4469-94kk8   0/1     Completed           0          3m10s
nginx-deployment-64cf9b4469-94kk8   0/1     Completed           0          3m10s
```

## Step 3 - Check revision History

Command: `kubectl rollout history -n cloudstation deployment/nginx-deployment`

Output:

```
deployment.apps/nginx-deployment 
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
```

## Step 4 - Describe the deployment

Command: `kubectl describe deployment -n cloudstation nginx-deployment`

Output: 

```
Name:                   nginx-deployment
Namespace:              cloudstation
CreationTimestamp:      Fri, 30 Aug 2024 04:12:29 -0600
Labels:                 app=nginx-deployment
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=nginx-deployment
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx-deployment
  Containers:
   nginx:
    Image:         nginx:1.26.2
    Port:          80/TCP
    Host Port:     0/TCP
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   nginx-deployment-64cf9b4469 (3/3 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  108s  deployment-controller  Scaled up replica set nginx-deployment-64cf9b4469 to 3
ksolorzanovalverde@R2H99M6ML7 ~ % kubectl describe deployment -n cloudstation nginx-deployment
Name:                   nginx-deployment
Namespace:              cloudstation
CreationTimestamp:      Fri, 30 Aug 2024 04:12:29 -0600
Labels:                 app=nginx-deployment
Annotations:            deployment.kubernetes.io/revision: 2
Selector:               app=nginx-deployment
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx-deployment
  Containers:
   nginx:
    Image:         nginx:1.27.1
    Port:          80/TCP
    Host Port:     0/TCP
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  nginx-deployment-64cf9b4469 (0/0 replicas created)
NewReplicaSet:   nginx-deployment-75fc4dddc5 (3/3 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  3m16s  deployment-controller  Scaled up replica set nginx-deployment-64cf9b4469 to 3
  Normal  ScalingReplicaSet  12s    deployment-controller  Scaled up replica set nginx-deployment-75fc4dddc5 to 1
  Normal  ScalingReplicaSet  9s     deployment-controller  Scaled down replica set nginx-deployment-64cf9b4469 to 2 from 3
  Normal  ScalingReplicaSet  9s     deployment-controller  Scaled up replica set nginx-deployment-75fc4dddc5 to 2 from 1
  Normal  ScalingReplicaSet  8s     deployment-controller  Scaled down replica set nginx-deployment-64cf9b4469 to 1 from 2
  Normal  ScalingReplicaSet  8s     deployment-controller  Scaled up replica set nginx-deployment-75fc4dddc5 to 3 from 2
  Normal  ScalingReplicaSet  7s     deployment-controller  Scaled down replica set nginx-deployment-64cf9b4469 to 0 from 1
```

# Extra

.yml file for reference: Inside of this repository named: "nginx-deployment.yaml"
