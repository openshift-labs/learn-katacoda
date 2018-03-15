# Lab 3 Exercises
Get into the right directory. By now, you should start to understand which of these command can be ran from directly on the how and which can be run from a super privileged container. Most of these commands will run just fine in a super privileged container, like accessing the hosts PID table, but some commands require access to the hosts's RPM database, which means it needs to be ran on the host or the RPM database directory needs mounted into a container to inspect it.

We suggest running all of these commands on the host for simplicity
```
cd /root/work/container-internals-lab/labs/lab-03/
```


## Exercise 1
The goal of this exercise is to gain a basic understanding of the APIs (Kubernetes/OpenShift, Docker, Linux kernel). First let's inspect the daemons which are running on the master nodes.
```
./exercise-01/mega-proc.sh docker
```

Pay attention to the following proecesses and daemons running. You may notice that all of the docker commands and daemons have the "-current" extension - this is a methodology Red Hat uses to specify which version of the tools are installed. Red Hat supports two versions - a fast moving version with the -latest extension and a stable version targetted for OpenShift with the -current extension.

These processes all work together to create a container in the Linux kernel. The following is a basic description of their purpose:

- **dockerd**: This is the main docker daemon. It handles all docker API calls (docker run, docker build, docker images) through either the unix socket /var/run/docker.sock or it can be configured to handle requests over TCP. This is the "main" daemon and it is started by systemd with the /usr/lib/systemd/system/docker.service unit file.
- **docker-containerd**: Containerd was recently open sourced as a separate community project. The docker daemon talks to containerd when it needs to fire up a container. More and more plumbing is being added to containerd (such as storage).
- **docker-containerd-shim**: this is a shim layer which starts the docker-runc-current command with the right options.
- **docker**: This is the docker command which you typed on the command line.


Now let's take a look at the OpenShift daemons which are runnning on the master:
```
./exercise-01/mega-proc.sh openshift
```

Pay particular attention the the following daemons. The OpenShift/Kubernetes code is very modular. OpenShift compiles all of the functionality into a single binary and determines which role the daemon will play with startup parameters. Depending on which installation method (single node, clustered, registry server only, manual) is chosen the OpenShift binaries can be started in different ways.

- **openshift start master api**: This process handles all API calls with REST, kubectl, or oc commands.
- **/usr/bin/openshift start node**: This process plays the role of the Kubelet and communicates with dockerd (which then communicates with the kernel) to create containers.
- **/usr/bin/openshift start master controllers**: This daemon embeds the core control loops shipped with Kubernetes. A controller is a control loop that watches the shared state of the cluster through the apiserver and makes changes attempting to move the current state towards the desired state. Examples of controllers that ship with Kubernetes today are the replication controller, endpoints controller, namespace controller, and serviceaccounts controller.


Now that you have an understanding of the different daemons, take a look at all of it together. Notice which daemons start which ones. Also, notice that the OpenShift API, Controller and Node processes are actually docker containers. There is roadmap to containerize the docker daemon on RHEL Atomic Host in the comming months as well.

```
ps aux --forest
```


## Exercise 2
The goal of this exercise is to gain a basic understanding of system calls and kernel namespaces. Linux system calls are a standard API interface to the Linux kernel. Every process in a Linux operating system uses system calls to gain access to resources (CPU, RAM, etc) and kernel data structures (files, file permissions, processes, sockets, pipes, etc).

First, let's inspect the system calls that a common command makes. If you have done any programming, a few of these system calls should be familiar - the **open** and **close** system calls open and close files. The **mprotect** and **mmap** system calls interact with memory. But, let's focus on a very important systemc call **execve** because this is the system call that strace (or the shell) uses to start the sleep process. Most normal Linux processes use some version of the **exec** or **fork** system call.
```
strace sleep 5
```

Now, let's inspect a containerized version of the same command. Use megaproc to get the PID and replace the -p argument:
```
./exercise-01/mega-proc.sh docker
```

Prepare to inspect what containerd is doing. Replace the -p argument with the PID for containerd:
```
strace -f -s4096 -e clone,getpid -p 10516
```

In a second terminal, run some commands, and inspect what happens in terminal 1. You will what containerd fire off clone() system calls to the kernel and create the container. The different flags passed to clone() are what determine which kernel namespaces will be used (network, pid, uid, gid, etc):
```
docker run -it rhel7 bash
```


## Exercise 3
The goal of this exercise is to gain a basic understanding of SELinux/sVirt. Run the following commands. Notice that each container is labeled with a dynamically generated MLS label. In the example below, the first container has an MLS label of c791,c940, while the second has a label of c169,c416. This extra layer of labeling prevents the processes from accessing each other's memory, files, etc. Copy and paste all four lines below, into a terminal:
```
docker run -t rhel7 sleep 10 &
docker run -t rhel7 sleep 10 &
sleep 3
ps -efZ | grep svirt | grep sleep
```

Output:
```
system_u:system_r:svirt_lxc_net_t:s0:c791,c940 root 54810 54796  1 00:40 pts/7 00:00:00 sleep 10
system_u:system_r:svirt_lxc_net_t:s0:c169,c416 root 54872 54858  1 00:40 pts/8 00:00:00 sleep 10
```

SELinux doesn't just label the processes, it must also label the files accessed by the process. Make a directory for data, and inspect the selinux label on the directory. Notice the type is set to "user_tmp_t" but there are no MLS labels set:
```
mkdir /tmp/selinux-test
ls -alhZ /tmp/selinux-test/
```

Output:
```
drwxr-xr-x. root root unconfined_u:object_r:user_tmp_t:s0 .
drwxrwxrwt. root root system_u:object_r:tmp_t:s0       ..
```

Now, run the following command a few times and notice the MLS labels change every time. This is sVirt at work:
```
docker run -t -v /tmp/selinux-test:/tmp/selinux-test:Z rhel7 ls -alhZ /tmp/selinux-test
```

Output:
```
drwxr-xr-x. root root system_u:object_r:svirt_sandbox_file_t:s0:c395,c498 .
drwxrwxrwt. root root system_u:object_r:svirt_sandbox_file_t:s0:c395,c498 ..
```

Look at the MLS label set on the directory, it is always the same as the last container that was run. The :Z option auto-labels and bind mounts so that the container can acess and change files in the mount. This prevents any other process from accessing this data. It's done transparently to the end user.
```
ls -alhZ /tmp/selinux-test/
```

## Exercise 4
The goal of this exercise is to gain a basic understanding of cgroups. Run two separate containerized sleep processes. Notice how each are put in their own cgroups. Copy and paste all four lines below, into a terminal:
```
docker run -t rhel7 sleep 10 &
docker run -t rhel7 sleep 10 &
sleep 3
for i in `docker ps | grep sleep | awk '{print $1}' | grep [0-9]`; do find /sys/fs/cgroup/ | grep $i; done
```

## Exercise 5
The goal of this exercise is to gain a basic understanding of SECCOMP. Take a look at this sample. This can be a very powerful tool to block malbehaved containers:
```
cat exercise-05/chmod.json
```

Now, run a container with this profile and test if it works. Notice how the chmod system call is blocked.
```
docker run -it --security-opt seccomp:exercise-05/chmod.json rhel7 chmod 777 /etc/hosts
```

## Exercise 6
The goal of this exercise is to gain a basic understanding of storage. Using "docker inspect" you can find the layers used in a particular container by looking at the GraphDriver -> Data.
```
docker inspect openshift3/ose-pod:v3.4.1.10 | grep GraphDriver -A 7
```

In The Class: The lab is set up with a tech preview of overlay2 support. Overlay2 makes it extremely easy to see the filesystem contents of every container because each directory represents a layer from the inspect output. Feel free to dig around in the directories based on the output of the above inspect command.
```
 ls -alh /var/lib/docker/overlay2/
 ````

Optional Homework: With device mapper, which is the default configuration in RHEL7 and Atomic Host
```
dmsetup ls --tree -o inverted
```

```
 (252:17)
 └─rhel-docker--pool_tdata (253:2)
    └─rhel-docker--pool (253:3)
       ├─docker-253:0-1402402-f70a1cebec4167011928bd416433cb8a88de3fe3c4cc2be3ab2aeab037493e94 (253:5)
       ├─docker-253:0-1402402-d84266b8f40669145a81d8d65129da46377b5638e529c57f2c34b53d209b1c67 (253:4)
       ├─docker-253:0-1402402-44b7ce3570b098fecf5d5435407d365ec854ece6eb8c7e2cd95cde69b85aa20d (253:7)
       └─docker-253:0-1402402-db523524bfa345fd768dfc1f89dadb01de3e424903470030ff4bd4b1a61e70d5 (253:6)
 (252:2)
 ├─rhel-docker--pool_tmeta (253:1)
 │  └─rhel-docker--pool (253:3)
 │     ├─docker-253:0-1402402-f70a1cebec4167011928bd416433cb8a88de3fe3c4cc2be3ab2aeab037493e94 (253:5)
 │     ├─docker-253:0-1402402-d84266b8f40669145a81d8d65129da46377b5638e529c57f2c34b53d209b1c67 (253:4)
 │     ├─docker-253:0-1402402-44b7ce3570b098fecf5d5435407d365ec854ece6eb8c7e2cd95cde69b85aa20d (253:7)
 │     └─docker-253:0-1402402-db523524bfa345fd768dfc1f89dadb01de3e424903470030ff4bd4b1a61e70d5 (253:6)
 └─rhel-root (253:0)
```

```
dmsetup status docker-253:0-1402402-db523524bfa345fd768dfc1f89dadb01de3e424903470030ff4bd4b1a61e70d5
0 20971520 thin 1391616 20971519
```
0 is starting point
20971520 (10GB) is length
This is a 10G thin volume


## Optional: Exercise 7
The goal of this exercise is to gain a basic understanding of container networking. First, start a container in OpenShift to work with:
```
oc run --restart=Never --attach --stdin --tty --image rhel7/rhel rhel-test bash
```

Once the container becomes active, bring up another terminal and run the the rest of the tests:
```
oc describe pod rhel-test
```

Output: 
```
Name:			rhel-test
Namespace:		lab02-exercise04
Security Policy:	anyuid
Node:			node3.ocp1.dc2.crunchtools.com/192.168.122.205
```

Now, ssh into the node where the pod is running and run the following commands. Notice that there are actually two docker containers running. One represents the pod and helps setup the network namespace, the second container actually runs the bash process. They both share the same network namespace.
```
docker ps | grep rhel-test
```

Output
```
56948c9d6a92        rhel7/rhel                                       "bash"                   6 minutes ago       Up 6 minutes                            k8s_rhel-test.e4ff8054_rhel-test_lab02-exercise04_0c5a6e56-25a3-11e7-9d46-525400b431c8_b46e2f45
093e63116819        openshift3/ose-pod:v3.4.1.10                     "/pod"                   6 minutes ago       Up 6 minutes                            k8s_POD.5aa7dc24_rhel-test_lab02-exercise04_0c5a6e56-25a3-11e7-9d46-525400b431c8_39480ba2
```

We can verify that both docker containers are placed in the same kernel network namespace, by verifying that they are using the same TCP stack.
```
DID=`docker ps | grep rhel-test | grep pod | awk '{print $1}'`
nsenter -t `docker inspect --format '{{ .State.Pid }}' $DID` -n ip addr
DID=`docker ps | grep rhel-test | grep bash | awk '{print $1}'`
nsenter -t `docker inspect --format '{{ .State.Pid }}' $DID` -n ip addr
```

Output for both
```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1
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
       valid_lft forever preferred_lft forever
```

Now, inspect the type of docker networking. OpenShift communicates with docker and starts a container with the None Mode networking. This causes a namespace to be created in the kernel, and then OpenShift configures the network. OpenShift then communicates with docker to start a second container with Container Mode networking, which places the bash process in the same network namespace as the first container. We can verify this with the following commands:

For the pod container:
```
DID=`docker ps | grep rhel-test | grep pod | awk '{print $1}'`
docker inspect $DID | grep NetworkMode
```

Output:
```
"NetworkMode": "none",
```

For the process container:
```
DID=`docker ps | grep rhel-test | grep bash | awk '{print $1}'`
docker inspect $DID | grep NetworkMode
```

Example Output:
```
"NetworkMode": "container:093e63116819781a2536587cf0af7d3a2e9c2444d3ddf143d4af5c85bda4a344"
```


## Optional: Exercise 8

*NOTE: There was change to this lab last minute, so the commands below need to be ran outside of a cotnainer. The concepts are identical and show that the network operates the same way whether OVS is containerized or not.

The goal of this exercise is to gain a basic understanding of the overlay network that enables multi-container networking. On any node, insepct the openvswtich container. Notice that the container is started with the following three options: --privileged --net=host --pid=host. These three options make this container super privileged similar to running a normal process as root. They also place the containerized proecess in the host's network namespace and process id namespace. Essentially, this privileged container only uses mount namespace to utilize a container image for delivery of software - hence, it has very limited containment.

```
ps -ef | grep "name openvswitch" | grep -v grep
```

```
/usr/bin/docker-current run --name openvswitch --rm --privileged --net=host --pid=host -v /lib/modules:/lib/modules -v /run:/run -v /sys:/sys:ro -v /etc/origin/openvswitch:/etc/openvswitch openshift3/openvswitch:v3.4.1.10
``` 

Exec into the container and look at the network. We have to run this command from inside of the openvswitch contianer because OVS is NOT installed on the Atomic Host. This really demonstrates the elegance of Linux Contianers. Even software such as Open vSwitch can be placed in a container. Notice that the tun0 interface has a different IP address on each node in the OpenShift cluster. Run the "ip addr" command on several masters or nodes in the cluster.
```
docker exec -t openvswitch ovs-vsctl show
docker exec -t openvswitch ip addr
```

Inspect the flow rules. There are specific flow rules for each of the other nodes in the cluster. OpenShift manages all of this for the administrator as nodes are added/removed.
```
docker exec -t openvswitch ovs-ofctl dump-flows br0 --protocols=OpenFlow13 | grep nw_dst=10.1
```

Output:
```
REG0[],goto_table:1
 cookie=0x0, duration=89147.397s, table=5, n_packets=0, n_bytes=0, priority=300,ip,nw_dst=10.1.0.1 actions=output:2
 cookie=0x0, duration=89147.374s, table=5, n_packets=0, n_bytes=0, priority=200,ip,nw_dst=10.1.0.0/24 actions=goto_table:7
 cookie=0x0, duration=89147.357s, table=5, n_packets=0, n_bytes=0, priority=100,ip,nw_dst=10.1.0.0/16 actions=goto_table:8
 cookie=0x0, duration=89147.233s, table=8, n_packets=0, n_bytes=0, priority=100,ip,nw_dst=10.1.4.0/24 actions=move:NXM_NX_REG0[]->NXM_NX_TUN_ID[0..31],set_field:192.168.122.205->tun_dst,output:1
 cookie=0x0, duration=89147.204s, table=8, n_packets=0, n_bytes=0, priority=100,ip,nw_dst=10.1.1.0/24 actions=move:NXM_NX_REG0[]->NXM_NX_TUN_ID[0..31],set_field:192.168.122.201->tun_dst,output:1
 cookie=0x0, duration=89147.180s, table=8, n_packets=0, n_bytes=0, priority=100,ip,nw_dst=10.1.2.0/24 actions=move:NXM_NX_REG0[]->NXM_NX_TUN_ID[0..31],set_field:192.168.122.202->tun_dst,output:1
 cookie=0x0, duration=89147.145s, table=8, n_packets=0, n_bytes=0, priority=100,ip,nw_dst=10.1.5.0/24 actions=move:NXM_NX_REG0[]->NXM_NX_TUN_ID[0..31],set_field:192.168.122.203->tun_dst,output:1
 cookie=0x0, duration=89147.040s, table=8, n_packets=0, n_bytes=0, priority=100,ip,nw_dst=10.1.3.0/24 actions=move:NXM_NX_REG0[]->NXM_NX_TUN_ID[0..31],set_field:192.168.122.204->tun_dst,output:1
```
