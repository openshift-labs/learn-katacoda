First and foremost, you need to understand that THE INTERNET IS WRONG. If you just do a quick Google search, you will find architectural drawing after architectural drawing which depict things the wrong way or depict only part of the whole picture, leading the viewer to come to the wrong conclusion about containers. One might suspect that the makers of many of these drawings have the wrong conclusion about how containers work. So, forget everything you think you know.

![Containers Are Linux](../../assets/subsystems/container-internals-lab-2-0-part-1/01-google-wrong.png)

How do people get it wrong? In two main ways:
 
First, most of the architectural drawings above show the docker daemon as a wide blue box stretched out over the container host. The containers are shown as if they are running on top of the docker daemon. This is incorrect - [containers don't run on docker](http://crunchtools.com/containers-dont-run-on-docker/). The docker engine is a general purpose container engine. Humans talk to container engines and container engines talk to the kernel - the containers are actually created and run by the Linux kernel. When drawings actually show the right architecture between the docker daemon and the kernel, they never show containers running side by side:

![Containers Are Linux](../../assets/subsystems/container-internals-lab-2-0-part-1/01-not-on-docker.png)

Second, if they understand that containers are Linux processes, they never show the container engine side by side with the containers. This leads people to never think about these two things together, giving the viewer only part of the story:

![Containers Are Linux](../../assets/subsystems/container-internals-lab-2-0-part-1/01-not-the-whole-story.png)
 
OK, let’s start from scratch. In the terminal, let's start with a simple experiment - start three containers which will all run the top command:

``docker run -td rhel7 top``{{execute}}''

``docker run -td rhel7 top``{{execute}}''

``docker run -td rhel7 top``{{execute}}''

Now, let's inspect the process table of the underlying host:

``ps -efZ | grep top``{{execute}}

Notice that even though we started each of the ``top`` commands in containers, they are still just a regular process which can be viewed with the trusty old ``ps`` command. That's because containerized processes are just [fancy Linux processes](http://sdtimes.com/guest-view-containers-really-just-fancy-files-fancy-processes/) with extra isolation from normal Linux processes. Hack around a bit, and notice that the docker daemon runs side by side with the containerized processes. A simplified drawing should really look something like this:

![Containers Are Linux](../../assets/subsystems/container-internals-lab-2-0-part-1/01-single-node-toolchain.png) 

In the kernel, there is no single data structure which represents what a container is. This has been debated back and forth for years - some people think there should be, others think there shouldn't. The current Linux kernel community philosophy is that the Linux kernel should provide a bunch of different technologies, ranging from experimental to very mature, enabling users to mix these technologies together in creative, new ways. And, that's exactly what a container engine (Docker, Podman, CRI-O) does - it leverages kernel technologies to create, what we humans call containers. The concept of a container is a user construct, not a kernel construct. This is a common pattern in Linux and Unix - this split between lower lovel (kernel) and higher level (userspace) technologies allows kernel developers to focus on enabling technologies, while users experiemnt with them and find out what works well.

![Containers Are Linux](../../assets/subsystems/container-internals-lab-2-0-part-1/01-kernel-engine.png)
 
The Linux kernel has only a single major data structure that tracks processes - the process id table. The '''ps''' command dumps the contents of this data structure. But, this is not the total definition of a container - the container engine tracks which kernel isolation technologies are used, and even what data volumes are mounted. This information can be thought of as metadata which provides a definition for what we humans call a container. We will dig deeper into the technical underpinnings, but for now, understand that containerized processes are regular Linux processes which are futher isolated using kernel technologies like namesspaces, selinux and cgroups. This is sometimes described as "sand boxing" or "isolation" or an "illusion" of virtualization.

In the end though, containerized processes are just regular Linux processes. All processes live side by side, whether they are regular Linux processes, long lived daemons, batch jobs, interactive commands which you run manually, or containerized processes. All of these processe make requests to the Linux kernel for protected resources like memory, RAM, TCP sockets, etc. We will explore this deeper in later labs, but for now, commit this to memory...
