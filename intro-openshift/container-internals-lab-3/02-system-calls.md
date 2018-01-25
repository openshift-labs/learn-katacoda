The goal of this exercise is to gain a basic understanding of system calls and kernel namespaces. Linux system calls are a standard API interface to the Linux kernel. Every process in a Linux operating system uses system calls to gain access to resources (CPU, RAM, etc) and kernel data structures (files, file permissions, processes, sockets, pipes, etc).

First, let's inspect the system calls that a common command makes. If you have done any programming, a few of these system calls should be familiar - the **open** and **close** system calls open and close files. The **mprotect** and **mmap** system calls interact with memory. But, let's focus on a very important systemc call **execve** because this is the system call that strace (or the shell) uses to start the sleep process. Most normal Linux processes use some version of the **exec** or **fork** system call.

`yum install strace -y`{{execute}}

``strace sleep 5``{{execute}}


Now, let's inspect a containerized version of the same command. Use megaproc to get the PID and replace the -p argument:

``mega-proc.sh docker``{{execute}}


Prepare to inspect what containerd is doing. Replace the -p argument with the PID for containerd:

``strace -f -s4096 -e clone,getpid -p REPLACE_WITH_PID_OF_DOCKERD``


In a second terminal, run some commands, and inspect what happens in terminal 1. You will what containerd fire off clone() system calls to the kernel and create the container. The different flags passed to clone() are what determine which kernel namespaces will be used (network, pid, uid, gid, etc):

``docker run -it rhel7 bash``{{execute}}

Finally, use ctrl-c to get out of the strace
