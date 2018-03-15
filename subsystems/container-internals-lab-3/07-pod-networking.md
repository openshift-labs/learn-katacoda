The goal of this exercise is to gain a basic understanding of container networking. First, we need a container to work with. In a **new** terminal, start a container in OpenShift:

``oc run --restart=Never --attach --stdin --tty --image rhel7/rhel rhel-test bash``{{execute}}


Once the container becomes active, run the following commands in your primary terminal:

``oc describe pod rhel-test``{{execute}}


Example Output:

``Name:			rhel-test
Namespace:		default
Security Policy:	anyuid
Node:			c3845a763c93/172.17.0.11``


In another terminal, run the following commands - in this lab, it's an all-in-one installation, so the master and node are running on the same host - but, in a live environment, you will need to ssh into the right node. Notice that there are actually two docker containers running. One represents the pod and helps setup the network namespace, the second container actually runs the bash process. They both share the same network namespace.

``docker ps | grep rhel-test``{{execute}}


Example Output

``56948c9d6a92        rhel7/rhel                                       "bash"                   6 minutes ago       Up 6 minutes                            k8s_rhel-test.e4ff8054_rhel-test_lab02-exercise04_0c5a6e56-25a3-11e7-9d46-525400b431c8_b46e2f45
093e63116819        openshift3/ose-pod:v3.4.1.10                     "/pod"                   6 minutes ago       Up 6 minutes                            k8s_POD.5aa7dc24_rhel-test_lab02-exercise04_0c5a6e56-25a3-11e7-9d46-525400b431c8_39480ba2``


We can verify that both docker containers are placed in the same kernel network namespace, by verifying that they are using the same TCP stack.

First, the pod container:

``DID=$(docker ps | grep rhel-test | grep pod | awk '{print $1}')
nsenter -t `docker inspect --format '{{ .State.Pid }}' $DID` -n ip addr``{{execute}}

Then, for the container running Bash:

``DID=$(docker ps | grep rhel-test | grep bash | awk '{print $1}')
nsenter -t `docker inspect --format '{{ .State.Pid }}' $DID` -n ip addr``{{execute}}


The output will be the same because they share a network namespace. Example output:

``1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
3: eth0@if94: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP 
    link/ether ce:43:4c:7d:59:68 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.1.4.2/24 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::cc43:4cff:fe7d:5968/64 scope link 
       valid_lft forever preferred_lft forever``


Now, inspect the type of docker networking. OpenShift communicates with docker and starts a container with the either the **none** or **default** mode networking. This causes a namespace to be created in the kernel, and then OpenShift configures the network. OpenShift then communicates with docker to start a second container with Container Mode networking, which places the bash process in the same network namespace as the first container. We can verify this with the following commands:

For the pod container:

``DID=$(docker ps | grep rhel-test | grep pod | awk '{print $1}')
docker inspect $DID | grep NetworkMode``{{execute}}


Output:

``"NetworkMode": "none",``


For the process (Bash) container:

``DID=$(docker ps | grep rhel-test | grep bash | awk '{print $1}')
docker inspect $DID | grep NetworkMode``{{execute}}


Example Output:

``"NetworkMode": "container:093e63116819781a2536587cf0af7d3a2e9c2444d3ddf143d4af5c85bda4a344"``

