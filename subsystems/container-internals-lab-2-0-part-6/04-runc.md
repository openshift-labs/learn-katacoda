The goal of this lab is to learn how to use the container runtime to communicate with the Linux kernel to start a container. You will build a simple set of metadata, and start a container. This will give you insight into what the [Container Engine](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.6yt1ex5wfo3l) is actually doing every time you run a command.

## Setup

To get runc to start a new container we need two main things:

1. A filesystem to mount (often called a RootFS)

2. A config.json file

First, lets create (or steal) a RootFS, which is really nothing more than a Linux distribution extracted into a directory. Podman makes this ridiculously easy to to do. The following command will fire up a container, get the ID, mount it, then rsync the filesystem contents out of it into a directory:

``rsync -av $(podman mount $(podman create fedora bash))/ /root/fedora/rootfs/``{{execute}}

We have ourselves a RootFS directory to work with, check it out:

``ls -alh /root/fedora/rootfs``{{execute}}

Now that we have a RootFS, lets create a spec file and modify it:

``rm -rf /root/fedora/config.json
runc spec -b /root/fedora/
sed -i 's/"terminal": true/"terminal": false/' /root/fedora/config.json``{{execute}}

Now, we have ourselves a full "bundle" which is a collequial way of referring to the RootFS and Config together in one directory:

``ls -alh /root/fedora``{{execute}}

## Experiments

First, lets create an empty container. This essentially creates the user space definition for the container, but no processes are spawned yet:

``runc create -b /root/fedora/ fedora``{{execute}}

List the created containers:

``runc list``{{execute}}

Now, lets execute a bash process in the container, so that we can see what's going on. Essentially, any number of processes can be exec'ed in the same namespace and they will all have access to the same PID table, Mount table, etc:

``runc exec --tty fedora bash``{{execute}}

It looks just like a normal container you would see with Podman, Docker or CRI-O inside of Kubernetes. That's because it is:

``ls``{{execute}}

Now, get out of the container:

``exit``{{execute}}

Delete it and verify that things are cleaned up. You may notice other containers running, that may be because other containers on the system are running in CRI-O, Podman, or Docker:

``runc delete fedora
runc list``{{execute}}

In summary, we have learned how to create containers with a terse little program called runc. This is the exact same program used by every major container engine on the planet. In production, you would never create containers like this, but it's useful to understand what is going on under the hood in CRI-O, Podman and Docker. When you run into new projects like Kata, gVisor, and others, you will now understand exactly how and where they fit in into the software stack.
