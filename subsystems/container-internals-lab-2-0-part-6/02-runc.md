The goal of this lab is to learn how to use the container runtime  to communicate with the Linux kernel to start a container. You will build a simple set of metadata, and start a container. This will give you insight into what the [Container Engine](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.6yt1ex5wfo3l) is actually doing every time you run a command.

To get runc to start a new container we need two main things:

1. A filesystem to mount (often called a RootFS)

2. A config.json file

First, lets get ourselves a RootFS, which is really nothing more than a Linux Distro uncompressed into a directory. Podman makes this rediculously easy to to do. The following command will fire up a container, get the ID, then rsync the filesystem contents out of it into a directory:

``rsync -av $(podman mount $(podman run -dt fedora bash))/ /root/fedora/``{{execute}}

Now, we have ourselves a directory to work with, check it out:

``ls -alh /root/fedora``{{execute}}

