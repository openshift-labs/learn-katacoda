We can now verify connectivity to our Memcached pool via Mcrouter.

Let's begin by exposing the Mcrouter Pod as a Service accessible to the Cluster.

```
oc expose deploy/mcrouter --name mcrouter --type=ClusterIP --target-port=5000
```{{execute}}
<br>
Create a temporary `telnet` Pod and connect to Mrouter:

```
kubectl run -it --rm telnet --image=jess/telnet --restart=Never mcrouter 5000
```{{execute}}
<br>
After a few seconds you will see a message `If you don't see a command prompt, try pressing enter.` **Do not press enter**.
<br>

Set a Memcached key called `ansible` with flags=`0`, ttl=`0`, and size=`8`:

```
set ansible 0 0 8
```{{execute}}
<br>
Set a value for the `ansible` key:

```
operator
```{{execute}}

Verify you can retrieve the value:

```
get ansible
```{{execute}}
<br>
Quit the `telnet` session:

```
quit
```{{execute}}