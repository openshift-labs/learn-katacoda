Red Hat Enterprise Linux is based off of the upstream Linux kernel and a bunch of users space packages put together in what is called a Linux distribution. In this same way, OpenShift is a distribution of Kubernetes. In this lab, we will take a look at the OpenShift distribution of Kubernetes. Much like Linux, there are small differences between distributions of Kubernetes - where configuration files are located, how daemons are started/stoped, etc. This lab is based on OpenShift, but everything you learn will be applicable to any distribution of Kubernetes.

The design of Kubernetes is modular in such a way that there is flexibility in how all of the daemons are started. This allows Kubernetes to scale to very large environments. It also allows flexibility in security and where API nodes are placed in the network. Generally, Kubernetes follows a master/node architecture, but the master can be broken up into multiple roles.

Now let's take a look at the daemons which are running on the master. OpenShift masters are typically installed with the OpenShift node daemons running as well, so you will see several different daemons running on these hosts. Now let's take a look for ourselves:

``mega-proc.sh openshift``{{execute}}

Notice that, like any container engine (podman, docker, containerd, etc), the OpenShift processes are just standard daemons running side by side with the containerized processes and all of the other processes on the system:

The OpenShift/Kubernetes code is very modular. OpenShift compiles all of the functionality into a single binary. When starting this binary, the user determines which role the daemon will play with startup parameters. Depending on which installation method is chosen (single node, clustered, registry server only, manual, etc), the OpenShift binaries can be started in different ways.

![Container Libraries](../../assets/subsystems/container-internals-lab-1/04-multi-host-toolchain.png)

In a highly available, multi-master environment, you will see all of the following daemons running. On smaller installations, or all-in-one test installations, several or all of these roles may be consolidated to a single master daemon. In any Kubernetes distribution the API and controllers functions can be run together or as separate processes on separate hosts.

Below is a basic description of each:

- **openshift start master api**: This process handles all API calls with REST, kubectl, or oc commands.
- **/usr/bin/openshift start node**: This process plays the role of the Kubelet and communicates with dockerd (which then communicates with the kernel) to create containers.
- **/usr/bin/openshift start master controllers**: This daemon embeds the core control loops shipped with Kubernetes. A controller is a control loop that watches the shared state of the cluster through the apiserver and makes changes attempting to move the current state towards the desired state. Examples of controllers that ship with Kubernetes today are the replication controller, endpoints controller, namespace controller, and serviceaccounts controller.
