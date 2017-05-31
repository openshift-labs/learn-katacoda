It's possible to leverage a lot of your existing architectural knowledge in a containerized environent. To do this, we need to understand some fundamental primatives including: libraries, containerized processes, regular processes, kernel data structures (namespaces, cgroups, SELinux). Containers started in the Linux kernel and remain there. What got easier over time, is how your start them - libraries like LXC, libcontainer, and LXD made it easier and easier to start containers on a Linux system.

![Kernel & Containers](../../assets/intro-openshift/container-internals-lab-1/Container-Internals-Lab-Kernel-Containers.png)

The docker command makes it really easy to start containers and even show which ones are running, but it actually relies on a lot of system libraries to communicate with the kernel. Libraries like libcontainer, libseccomp, libselinux, libpcap and libc all assist in interacting with the kernel. Storage, network, process, and security data structures are all manipulated when a container is started or stopped.

``ldd /usr/bin/docker-current``{{execute}}

Let's move on...
