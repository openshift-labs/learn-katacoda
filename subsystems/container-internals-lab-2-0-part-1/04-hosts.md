To understand the Container Host we must analyze the layers that work together to create a container. They include:

* [Container Engine](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.6yt1ex5wfo3l)
* [Container Runtime](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.6yt1ex5wfo55)
* Linux Kernel

## Container Engine
A container engine can loosely be described as any tool which provides an API or CLI for building or running containers. This started with Docker, but also includes Podman, Buildah, RKT, and CRi-O. A container engine accepts user inputs, pulls container images, creates some metadata describiung how to run the container, then passes this information to a container Runtime.

## Container Runtime
A container runtime is a small tool that expects to be handed two things - a directory often called a rootfilesystem or rootfs, and some metadata called a a config.json. The most commone runtime is [runc](https://github.com/opencontainers/runc) but there are many experimental ones including katacontainers, gvisor, crun, and railcar.

## Linux Kernel
The kernel is responsible for the last mile of container creation, as well as resource management during it's running lifecycle. The container runtime talks to the kernel to create the new container with a special kernel function called clone(). The runtime also handles talking to the kernel to configure things like cgroups, SELinux, and SECCOMP (more on these later).


![Containers Are Linux](../../assets/subsystems/container-internals-lab-2-0-part-1/04-simple-container-engine.png)

 
Running containers are just regular Linux processes that were started by a container runtime instead of a shell. All Linux processes live side by side, whether they are daemons, batch jobs, interactive commands in a shell, the container engine, the contianer runtime, or containers which are child processes of the runtime. All of these processe make requests to the Linux kernel for protected resources like memory, RAM, TCP sockets, etc. 

Execute a few commands with podman and notice the process IDs, and namespace IDs. Containers are just regular processes:

`podman ps -ns`{{execute}}
`podman top -l huser user hpid pid %C etime tty time args`{{execute}}
`ps -ef | grep 3306`

We will explore this deeper in later labs, but for now, commit this to memory, containers are linux...

