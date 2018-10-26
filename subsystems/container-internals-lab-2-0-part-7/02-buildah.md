The goal of this lab is to introduce you to Buildah and the flexibility it provides when you need to build container images your way. There are a lot of different use cases that just "feel natural" when building container images, but you often, you can't quite wire together and elegant solutions with the client server model of existing container engines. In comes Buildah. To get started, lets introduce some basic decions you need to think through when building a new container image.

1. Image vs. Scratch: Do you want to start with an existing container image as the source for your new container image, or would you prefer to build completely from scratch. Source images are the most common route, but it can be nice to build from scratch if you have small, statically linked binaries.

2. Inside vs. Outside: Do you want to execute the commands to build the next container image layer inside the container, or would you prefer to use the tools on the host to build the image. This is completely new concept with Buildah, but with existing container engines, you always build from within the container. Building outside the container image can be useful when you want to build a smaller container image, or an image that will always be ran read only, and never built upon. Things like Java would normally be built in the container because they typically need a JVM running, but installing RPMs might happen from outside because you don't want the RPM database in the container.

3. External vs. Internal Data: Do you have everything you need to build the image from within the image? Or, do you need to access cached data outside of the build process? For example, It might be convenient to mount a large cached RPM cache indside the container during build, but you would never want to carry that around in the production image. The use cases for build time mounts range from SSH keys to Java build artifacts - for more ideas, see this [GitHub issue](https://github.com/moby/moby/issues/14080).


Alright, let's walk through some common scenarios with Buildah.

## Basic Build

First declare what image you want to start with as a source. In this case, we will start with Fedora:

``buildah from fedora``{{execute}}

This will create a "reference" to what buildah calls a "working containers" - think of them as a starting point to attach mounts and commands. Check it out here:

``buildah containers``{{execute}}

Now, we can mount the image source. In effect, this will trigger the graph driver to do its magic, pull the image layers together, add a working copy-on-write layer, and mount it so that we can access it just like any directory on the system:

``buildah mount fedora-working-container``{{execute}}

Now, lets add a single file to the new contianer image layer. The buildah mount command can be ran again to get access to the right directory:

``echo "hello world" > $(buildah mount fedora-working-container)/etc/hello.conf``{{execute}}

Lets analyze what we just did. It's super simple, but kind of mind bending if you come from using other container engines. First, list the directory in the copy-on-write layer:

``ls -alh $(buildah mount fedora-working-container)/etc/``{{execute}}

You should see hello.conf right there. Now, cat the file:

``cat $(buildah mount fedora-working-container)/etc/hello.conf``{{execute}}``

You should see the text you expect. Now, lets commit this copy-on-write layer as a new image layer:

``buildah commit fedora-working-container fedora-hello``{{execute}}

Now, we can see the new image layer in our local cache. We can view it with either Podman or Buildah (or CRI-O for that matter, they all use the same image store):

``buildah images``{{execute}}

``podman images``{{execute}}

When we are done, we can clean up our environment quite nicely. The following command will delete references to "working containers" and completely remove their mounts:

``buildah delete -a``{{execute}}

But, we still have the new image layer just how we want it. This could be pushed to a registry server to be shared with others if we like:

``buildah images``{{execute}}

``podman images``{{execute}}

## Using Tools Outside The Container

Create a new working container, mount the image, and get a working copy-on-write layer:

``WORKING_MOUNT=$(buildah mount $(buildah from scratch))
echo $WORKING_MOUNT``{{execute}}

Verify that there is nothing in the directory:

``ls -alh $WORKING_MOUNT``{{execute}}

Now, lets install some basic tools:

yum install --installroot $WORKING_MOUNT bash coreutils --releasever 7 --setopt install_weak_deps=false -y
yum clean all -y --installroot $WORKING_MOUNT --releasever 7

## External Build Time Mounts


