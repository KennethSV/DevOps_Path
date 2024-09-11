# CloudStation Challenge

## Challenge Objectives

1. Using taints over a node named: "k8s4devs-worker2" with the following key and value: "cloud-station:true" and the effect "NoSchedule". This taint will be the barrier that will maintain any ordinary pod outside the CloudStation.
2. Create a POD that has the tolerance to survive the CloudStation. This POD should have a tolerance that allows the allocation secured by the taint configured before.

### Creating a new Cluster

A new cluster with a master and 2 worker nodes was created. 

- Cluster Configuration: kind-config.yaml

Command to start the cluster: 

`kind create cluster --name k8s4devs --config kind-config.yaml`

Verification of running nodes:

```txt
# kubectl get nodes -A
NAME                     STATUS   ROLES           AGE     VERSION
k8s4devs-control-plane   Ready    control-plane   3m36s   v1.31.0
k8s4devs-worker          Ready    <none>          3m20s   v1.31.0
k8s4devs-worker2         Ready    <none>          3m20s   v1.31.0
```

### Adding taint based on objective 1

`kubectl taint nodes k8s4devs-worker2 cloud-station=true:NoSchedule`

Output should be: 

```txt
node/k8s4devs-worker2 tainted
```

Verification that the Taint has been added:

`kubectl describe nodes k8s4devs-worker2`

Output:
```
Name:               k8s4devs-worker2
Roles:              <none>
Labels:             beta.kubernetes.io/arch=arm64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=arm64
                    kubernetes.io/hostname=k8s4devs-worker2
                    kubernetes.io/os=linux
Annotations:        kubeadm.alpha.kubernetes.io/cri-socket: unix:///run/containerd/containerd.sock
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Wed, 11 Sep 2024 01:09:47 -0600
Taints:             cloud-station=true:NoSchedule # Taint was clearly added
Unschedulable:      false
Lease:
  HolderIdentity:  k8s4devs-worker2
  AcquireTime:     <unset>
  RenewTime:       Wed, 11 Sep 2024 01:15:33 -0600
Conditions:
  Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----             ------  -----------------                 ------------------                ------                       -------
  MemoryPressure   False   Wed, 11 Sep 2024 01:15:04 -0600   Wed, 11 Sep 2024 01:09:47 -0600   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure     False   Wed, 11 Sep 2024 01:15:04 -0600   Wed, 11 Sep 2024 01:09:47 -0600   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure      False   Wed, 11 Sep 2024 01:15:04 -0600   Wed, 11 Sep 2024 01:09:47 -0600   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready            True    Wed, 11 Sep 2024 01:15:04 -0600   Wed, 11 Sep 2024 01:09:59 -0600   KubeletReady                 kubelet is posting ready status
Addresses:
  InternalIP:  172.18.0.3
  Hostname:    k8s4devs-worker2
Capacity:
  cpu:                10
  ephemeral-storage:  61202244Ki
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  hugepages-32Mi:     0
  hugepages-64Ki:     0
  memory:             8026892Ki
  pods:               110
Allocatable:
  cpu:                10
  ephemeral-storage:  61202244Ki
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  hugepages-32Mi:     0
  hugepages-64Ki:     0
  memory:             8026892Ki
  pods:               110
System Info:
  Machine ID:                 e78f6d0699834939b91e1b051572670f
  System UUID:                e78f6d0699834939b91e1b051572670f
  Boot ID:                    17b41c96-101f-401b-9d2d-7d5fdacf07db
  Kernel Version:             6.10.0-linuxkit
  OS Image:                   Debian GNU/Linux 12 (bookworm)
  Operating System:           linux
  Architecture:               arm64
  Container Runtime Version:  containerd://1.7.18
  Kubelet Version:            v1.31.0
  Kube-Proxy Version:         
PodCIDR:                      10.244.2.0/24
PodCIDRs:                     10.244.2.0/24
ProviderID:                   kind://docker/k8s4devs/k8s4devs-worker2
Non-terminated Pods:          (2 in total)
  Namespace                   Name                CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
  ---------                   ----                ------------  ----------  ---------------  -------------  ---
  kube-system                 kindnet-cxtnk       100m (1%)     100m (1%)   50Mi (0%)        50Mi (0%)      5m49s
  kube-system                 kube-proxy-w96h5    0 (0%)        0 (0%)      0 (0%)           0 (0%)         5m49s
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests   Limits
  --------           --------   ------
  cpu                100m (1%)  100m (1%)
  memory             50Mi (0%)  50Mi (0%)
  ephemeral-storage  0 (0%)     0 (0%)
  hugepages-1Gi      0 (0%)     0 (0%)
  hugepages-2Mi      0 (0%)     0 (0%)
  hugepages-32Mi     0 (0%)     0 (0%)
  hugepages-64Ki     0 (0%)     0 (0%)
Events:
  Type    Reason                   Age                    From             Message
  ----    ------                   ----                   ----             -------
  Normal  Starting                 5m47s                  kube-proxy       
  Normal  NodeHasNoDiskPressure    5m51s                  kubelet          Node k8s4devs-worker2 status is now: NodeHasNoDiskPressure
  Normal  NodeHasSufficientPID     5m51s                  kubelet          Node k8s4devs-worker2 status is now: NodeHasSufficientPID
  Normal  Starting                 5m49s                  kubelet          Starting kubelet.
  Normal  NodeHasSufficientMemory  5m49s (x2 over 5m49s)  kubelet          Node k8s4devs-worker2 status is now: NodeHasSufficientMemory
  Normal  NodeHasNoDiskPressure    5m49s (x2 over 5m49s)  kubelet          Node k8s4devs-worker2 status is now: NodeHasNoDiskPressure
  Normal  NodeHasSufficientPID     5m49s (x2 over 5m49s)  kubelet          Node k8s4devs-worker2 status is now: NodeHasSufficientPID
  Normal  NodeAllocatableEnforced  5m49s                  kubelet          Updated Node Allocatable limit across pods
  Normal  RegisteredNode           5m47s                  node-controller  Node k8s4devs-worker2 event: Registered Node k8s4devs-worker2 in Controller
  Normal  NodeReady                5m37s                  kubelet          Node k8s4devs-worker2 status is now: NodeReady
```

### Creating a pod to survive the tainted on POD-2

Created a pod with the tolerations required based on the tainted configuration on worker2 node

Configuration: pod-config.yaml

Deploying POD:

`kubectl apply -f pod-config.yaml`

Confirm that the pod has pass the test:

`kubectl get pods -n cloudstation`

Output:

```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-6bf87c998b-8cvf2   1/1     Running   0          79s
```

Describe the above pod:

`kubectl describe pod nginx-deployment-6bf87c998b-8cvf2 -n cloudstation`

Output: 

```
Name:             nginx-deployment-6bf87c998b-8cvf2
Namespace:        cloudstation
Priority:         0
Service Account:  default
Node:             k8s4devs-worker2/172.18.0.3
Start Time:       Wed, 11 Sep 2024 01:22:01 -0600
Labels:           app=nginx-deployment
                  pod-template-hash=6bf87c998b
Annotations:      <none>
Status:           Running
IP:               10.244.2.2
IPs:
  IP:           10.244.2.2
Controlled By:  ReplicaSet/nginx-deployment-6bf87c998b
Containers:
  nginx:
    Container ID:   containerd://07bbab7fb3fab781c0ff09d55398e7696bce23b69c1b0311f22de2a25d9b40dc
    Image:          nginx:1.26.2
    Image ID:       docker.io/library/nginx@sha256:8c374b0fc0aa5416d5fd4661a6d91635e9ddda57c6b826aec4ea4a37b45ddceb
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Wed, 11 Sep 2024 01:22:12 -0600
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-pkstm (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  kube-api-access-pkstm:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 cloud-station=true:NoSchedule
                             node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  96s   default-scheduler  Successfully assigned cloudstation/nginx-deployment-6bf87c998b-8cvf2 to k8s4devs-worker2
  Normal  Pulling    95s   kubelet            Pulling image "nginx:1.26.2"
  Normal  Pulled     85s   kubelet            Successfully pulled image "nginx:1.26.2" in 10.147s (10.147s including waiting). Image size: 67692990 bytes.
  Normal  Created    85s   kubelet            Created container nginx
  Normal  Started    85s   kubelet            Started container nginx
```

Verifying the last event from scheduler, it was seen that the pod was successfully assigned to k8s4devs-worker2.
