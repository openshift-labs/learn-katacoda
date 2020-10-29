## Background
This lab focuses on understanding how a particular host actually runs the container images - from the deep internals of how containerized processes interact with the Linux kernel, to the docker daemon and how it receives REST API calls and translates them into system calls to tell the Linux kernel to create new containerized processes.

By the end of this lab you should be able to:
- Understand the basic interactions of the major daemons and APIs in a typical container environment
- Internalize the function of system calls and kernel namespaces
- Understand how SELinux and sVirt secures containers
- Command a conceptual understanding of how cgroups limit containers
- Use SECCOMP to limit the system calls a container can make
- Have a basic understanding of container storage and how it compares to normal Linux storage concepts
- Gain a basic understanding of container networking and namespaces
- Troubleshoot a basic Open vSwitch setup with Kubernetes/OpenShift

## Outline
- Daemons & APIs: Docker, Kubernetes Master, Node, and their interaction with the Linux kernel
- System Calls & Kernel Namespaces: How they work inside of a container
- SELinux & sVirt: Dynamically generated contexts to protect your containers
- Cgroups: Dynamically created with container instantiation
- SECCOMP: Limiting how a containerized process can interact with the kernel
- Storage: How containers get local, copy on write storage
- Pod Networking: How individual containers and pods connect to the network
- Cluster Networking: How clusters of hosts manage the connections of containerized processes

## Other Material
This video will give you a background to all of the concepts in this lab
- [Presentation](https://goo.gl/UNnLkH)
- [Lab GitHub Repository](https://github.com/openshift-labs/learn-katacoda)

## Start Scenario
Once you have watched the background video or went throught the presentation, continue to the exercises
