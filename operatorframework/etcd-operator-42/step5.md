Let's now create another pod and attempt to connect to the etcd cluster via `etcdctl`:

```
oc run etcdclient --image=busybox busybox --restart=Never -- /usr/bin/tail -f /dev/null
```{{execute}}
<br>
Access the pod:

``` 
oc rsh etcdclient
```{{execute}}
<br>

Install the Etcd Client:

```
wget https://github.com/coreos/etcd/releases/download/v3.1.4/etcd-v3.1.4-linux-amd64.tar.gz
tar -xvf etcd-v3.1.4-linux-amd64.tar.gz
cp etcd-v3.1.4-linux-amd64/etcdctl .
```{{execute}}
<br>
Set the etcd version and endpoint variables:

```
export ETCDCTL_API=3
export ETCDCTL_ENDPOINTS=example-etcd-cluster-client:2379
```{{execute}}
<br>
Attempt to write a key/value into the Etcd cluster:

```
./etcdctl put operator sdk
./etcdctl get operator
```{{execute}}
<br>
Exit out of the client pod:

```
exit
```{{execute}}
<br>
