Learning container internals is really about applying what you already know. With just a bit of training to bridge some gaps, it's possible to apply all of your existing Linux/Unix knowledge. This will allow you to build better containerized applications and better container host clusters. To bridge the gap, we need to refresh our understanding of some fundamental primitives including libraries, Linux processes, and system calls, as well as kernel technologies such as namespaces, cgroups, and SELinux. 

Processes are inherently part of the operating system kernel and this doesn't change with containers. Containers are just processes, which are isolated more than regular processes. But, how much? That question requires some nuance to answer.

There is not, and never has been, a canonical defintion for what a container is in the Linux kernel. The Linux kernel has no single data structure which reprents one. Each library, tool, or daemon that purports to create a *container*, has it's own unique defition - these are user space definitions for what a container is - and this made it difficult for users to know which one to use.

Another problem, historically, is the mechanisms to distribute, manage and run containers were difficult to use. They required cryptic command line options, and the management of cumbersome disk images. This has changed over time. Libraries and daemons like LXC, libcontainer, LXD, Docker and Kubernetes made it easier and easier to run containers on a Linux system. But, we still had a problem - of all of these libraries and daemons. Which ones should we use?

With the advent of Docker and Kubernetes, this problem has been solved. Almost all modern container runtimes consume and run container images defined by the Open Containers Initiatve (OCI). The docker format which essentially became OCI has changed everything. We finally have a user space definition that allows us to build an ecosystem of tools. The best part is, the format is compatibile with tool chains in Linux and Windows, so Registry Servers and other infrastructure can be shared.

But, the running containerized processes are still managed by the operating system kernel, and the user space tool chain in the container images is still built and managed by Linux distributions. Everything has changed, and nothing has changed.

![Container Libraries](../../assets/intro-openshift/container-internals-lab-1/02-container-libraries.png)

Since most of you probably have experience with Docker, we will start with that - later we will move on to Kubernetes. The docker command changed the world because it makes it really easy to start a couple of containers and even show which ones are running. In fact, the concept of a "docker container" is a user space construct, but it actually relies on a lot of system libraries to communicate with the kernel. Libraries like libcontainer, libseccomp, libselinux, libpcap and libc all assist in interacting with the kernel. Storage, network, process, and security data structures are all manipulated when a container is started or stopped. Take a quick look at the libraries that the docker daemon uses:

``ldd /usr/bin/docker-current``{{execute}}

Let's move on...
