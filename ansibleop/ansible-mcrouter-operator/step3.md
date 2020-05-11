We can now verify connectivity to our Memcached pool via Mcrouter.

Let's begin by exposing the Mcrouter Pod as a Service accessible to the Cluster.

```
oc expose deploy/mcrouter --name mcrouter --type=ClusterIP --target-port=5000
```{{execute}}
<br>
Create a temporary telnet Pod and connect to Mrouter:

```
oc run -it --rm telnet --image=jess/telnet --restart=Never mcrouter 5000
```{{execute}}
<br>
After a few seconds you will see a message `If you don't see a command prompt, try pressing enter.` ***Do not press enter***. Run the following commands to insert a key/value and exit:

```
set ansible 0 0 8
operator
get ansible
quit
```{{execute}}
<br>
We can also utilize the `mcperf` tool for measuring Memcached server performance.

This command will create ***1000*** connections to Mcrouter. The connections are created at the rate of ***1000*** conns/sec and on every connection it sends ***10*** `set` requests at the rate of ***1000*** reqs/sec with the item sizes derived from a uniform distribution in the interval of 1 to 16 bytes:

```
oc run -it --rm mcperf --image=quay.io/redhat/mcperf --restart=Never -- -s mcrouter -p 5000 --linger=0 --timeout=5 --conn-rate=1000 --call-rate=1000 --num-calls=10 --num-conns=1000 --sizes=u1,16
```{{execute}}
<br>
We should be able to see a significant spike in CPU/Memory usage from running the above command. You can check it out by selecting the ***Console*** tab which will open the OpenShift dashboard. Log in with username: `admin`, password: `admin`, and then select ***Monitoring*** --> ***Dashboards***. Also be sure to run the following command:

```
oc adm policy add-cluster-role-to-user cluster-admin admin
```{{execute}}
