Let's begin my creating a new project called `myproject`:

```
oc new-project myproject
```{{execute}}
<br>
Create a new pod manifest that specifies two containers:

```
cat > pod-multi-container.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: my-two-container-pod
  namespace: myproject
  labels:
    environment: dev
spec:
  containers:
    - name: server
      image: nginx:1.13-alpine
      ports:
        - containerPort: 80
          protocol: TCP
    - name: side-car
      image: alpine:latest
      command: ["/usr/bin/tail", "-f", "/dev/null"]
  restartPolicy: Never
EOF
```{{execute}}
<br>
Create the pod by specifying the manifest:

```
oc create -f pod-multi-container.yaml
```{{execute}}
<br>
View the detail for the pod and look at the events:

```
oc describe pod my-two-container-pod
```{{execute}}
<br>
Let's first execute a shell session inside the server container by using the
`-c` flag:

```
oc exec -it my-two-container-pod -c server -- /bin/sh
```{{execute}}
<br>
Run some commands inside the server container:

```
ip address
netstat -ntlp
hostname
ps
exit
```{{execute}}
<br>
Let's now execute a shell session inside the side-car container:

```
oc exec -it my-two-container-pod -c side-car -- /bin/sh
```{{execute}}
<br>
Run the same commands in side-car container. Each container within a pod runs
it's own cgroup, but shares IPC, Network, and UTC (hostname) namespaces:

```
ip address
netstat -ntlp
hostname
exit
```{{execute}}