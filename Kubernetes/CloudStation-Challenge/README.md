# CloudStation Challenge

## Challenge Objectives

1. Using taints over a node named: "k8s4devs-worker2" with the following key and value: "cloud-station:true" and the effect "NoSchedule". This taint will be the barrier that will maintain any ordinary pod outside the CloudStation.
2. Create a POD that has the tolerance to survive the CloudStation. This POD should have a tolerance that allows the allocation secured by the taint configured before.

### Creating a new Cluster

A new cluster with a master and 2 worker nodes was created. 

- Cluster Configuration: kind-config.yaml

Command to start the cluster: 

`kind create cluster --name cloudstation-challenge --config kind-config.yaml`

Verification of running nodes:

```txt
# kubectl get nodes -A
NAME                                   STATUS   ROLES           AGE   VERSION
cloudstation-challenge-control-plane   Ready    control-plane   45s   v1.31.0
cloudstation-challenge-worker          Ready    <none>          34s   v1.31.0
cloudstation-challenge-worker2         Ready    <none>          34s   v1.31.0
```

### Adding taint based on objective 1

kubectl taint nodes node1 key1=value1:NoSchedule
