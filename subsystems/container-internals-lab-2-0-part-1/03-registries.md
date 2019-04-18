Registries are really just fancy file servers that help users share container images with each other. The magic of containers is really the ability to find, run, build, share and collaborate with a new packaging format that groups applications and all of their dependencies together.

![Container Libraries](../../assets/subsystems/container-internals-lab-2-0-part-1/03-basic-container-registry.png)

Container images make it easy for software builders to package software, as well as guidlines on how to run it. Using metadata, software builders can communicate how users *can* and *should* run their software, while providing the flexibility to also build off of it.

Registry servers just make it easy to share this work with other users. Builders can push an image once allowing users and even automation like CI/CD systems to pull it down and use it thousands or millions of times. Some registries like the [Red Hat Container Catalog](https://access.redhat.com/containers/) offer images which are highly curated, well tested, and enterprise grade. Others, like [Quay.io](http://quay.io) are cloud based registries that give individual users public and private spaces to push and share images. Each have use cases which they are good for.

As an example which demonstrates the power of sharing with quay.io, lets pull down a container image that was designed and built for this lab:

`podman pull quay.io/fatherlinux/linux-container-internals-2-0-introduction`{{execute}}

Now, run this database similuation:

`podman run -d -p 3306:3306 quay.io/fatherlinux/linux-container-internals-2-0-introduction`{{execute}}

Now, poll the simulated database with our very simple client, curl:

`curl localhost:3306`{{execute}}

This image was built with an extremely simple build file, but notice all of the logic to run it correctly was built in:

~~~~
#
# Version 1

# Pull from fedora Base Image
FROM registry.access.redhat.com/ubi7-dev-preview/ubi-minimal

MAINTAINER Scott McCarty smccarty@redhat.com

# Update the image
RUN yum -y install nmap-ncat

# Output
ENTRYPOINT bash -c 'while true; do /usr/bin/nc -l -p 3306 < /etc/redhat-release; done'
~~~~

Realizing how easy it is to build and share using registry servers is the goal of this lab. Notice that you can embed logic of how to start the container image in the build file, thereby communicating not just *what* to run, but also *how*.

Now, lets move on to container hosts...
