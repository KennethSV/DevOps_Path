# Communication between pods on different namespaces Challenge

## Create the necessary namespaces

For this challenge it was asked to create 2 namespaces, with the following names:

- namespace-1
- namespace-2

In order to create this the following commands were executed: 

`kubectl create namespace namespace-1`
`kubectl create namespace namespace-2`

## Create two deployments, each on each namespace

On this example, it was used the already .yaml file for nginx application, but doing a modification on the namespace for each of them. 

The files used for this step were:

1. nginx-ns-1.yaml
2. nginx-ns-2.yaml

Commands to start the deployments: 

`kubectl apply -f nginx-ns-1.yaml`
`kubectl apply -f nginx-ns-2.yaml`

### Verification that the deployments were created on each namespace:

`kubectl get deployments -A`

```
NAMESPACE            NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
kube-system          coredns                  2/2     2            2           41m
local-path-storage   local-path-provisioner   1/1     1            1           41m
namespace-1          nginx-ns1                3/3     3            3           17m
namespace-2          nginx-ns2                3/3     3            3           14m
```

`kubectl get pods -A`

```
NAMESPACE            NAME                                         READY   STATUS    RESTARTS   AGE
kube-system          coredns-6f6b679f8f-sb9br                     1/1     Running   0          44m
kube-system          coredns-6f6b679f8f-zn69n                     1/1     Running   0          44m
kube-system          etcd-kind-control-plane                      1/1     Running   0          44m
kube-system          kindnet-2qbpq                                1/1     Running   0          44m
kube-system          kindnet-mtcpw                                1/1     Running   0          44m
kube-system          kindnet-rqmxl                                1/1     Running   0          44m
kube-system          kube-apiserver-kind-control-plane            1/1     Running   0          44m
kube-system          kube-controller-manager-kind-control-plane   1/1     Running   0          44m
kube-system          kube-proxy-9r6zt                             1/1     Running   0          44m
kube-system          kube-proxy-fctz7                             1/1     Running   0          44m
kube-system          kube-proxy-w2pws                             1/1     Running   0          44m
kube-system          kube-scheduler-kind-control-plane            1/1     Running   0          44m
local-path-storage   local-path-provisioner-57c5987fd4-8j24l      1/1     Running   0          44m
namespace-1          busybox                                      1/1     Running   0          8m15s
namespace-1          nginx-ns1-7bdc884756-k2d4x                   1/1     Running   0          20m
namespace-1          nginx-ns1-7bdc884756-xs5kh                   1/1     Running   0          20m
namespace-1          nginx-ns1-7bdc884756-zw4b9                   1/1     Running   0          20m
namespace-2          nginx-ns2-55c46975bf-4mk58                   1/1     Running   0          17m
namespace-2          nginx-ns2-55c46975bf-jbj7l                   1/1     Running   0          17m
namespace-2          nginx-ns2-55c46975bf-klgfc                   1/1     Running   0          17m
```

Note: Please notice that based on the challenge it was asked that each deployment contained at least 3 replicas of the pod. This was accomplished based on the configuration set on the deployment yaml. 

## Create the services for each deployment

It was created a new .yaml for the service of each deployment. The file names used were: 

1. clusterIP-ns1.yaml
2. clusterIP-ns2.yaml

Commands to start the services: 

`kubectl apply -f clusterIP-ns1.yaml`
`kubectl apply -f clusterIP-ns2.yaml`

### Verification of the creation of the services

`kubectl get svc -n namespace-1`

```
NAME                      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
nginx-ns1-clusterip-svc   ClusterIP   10.96.241.20   <none>        80/TCP    14m
```

`kubectl get svc -n namespace-2`

```
NAME                      TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
nginx-ns2-clusterip-svc   ClusterIP   10.96.53.34   <none>        80/TCP    14m
```

## Test

Execute bash shell from one of the pods, and try the connection to the service on the other namespace

### Namespace 1 -> Namespace 2

#### Retrieve the name of each of the pods from "namespace-1":

`kubectl get pods -n namespace-1`

```
NAME                         READY   STATUS    RESTARTS   AGE
nginx-ns1-7bdc884756-k2d4x   1/1     Running   0          27m
nginx-ns1-7bdc884756-xs5kh   1/1     Running   0          27m
nginx-ns1-7bdc884756-zw4b9   1/1     Running   0          27m
```

#### Execute bash shell from any of the pods:

`kubectl exec -it nginx-ns1-7bdc884756-k2d4x -n namespace-1 -- /bin/bash`

#### Try connecting to the service on the other namespace

`curl http://nginx-ns2-clusterip-svc.namespace-2`

Successful Response: 

```
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

### Namespace 2 -> Namespace 1

#### Retrieve the name of each of the pods from "namespace-2":

`kubectl get pods -n namespace-2`

```
NAME                         READY   STATUS    RESTARTS   AGE
nginx-ns2-55c46975bf-4mk58   1/1     Running   0          29m
nginx-ns2-55c46975bf-jbj7l   1/1     Running   0          29m
nginx-ns2-55c46975bf-klgfc   1/1     Running   0          29m
```

#### Execute bash shell from any of the pods:

`kubectl exec -it nginx-ns2-55c46975bf-4mk58 -n namespace-2 -- /bin/bash`

#### Try connecting to the service on the other namespace

`curl http://nginx-ns1-clusterip-svc.namespace-1`

Successful Response: 

```
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
