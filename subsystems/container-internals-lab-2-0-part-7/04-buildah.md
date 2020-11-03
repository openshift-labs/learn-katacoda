The goal of this lab is to introduce you to Buildah and the flexibility it provides when you need to build container images your way. There are a lot of different use cases that just "feel natural" when building container images, but you often, you can't quite wire together and elegant solutions with the client server model of existing container engines. In comes Buildah. To get started, lets introduce some basic decisions you need to think through when building a new container image.

1. Image vs. Scratch: Do you want to start with an existing container image as the source for your new container image, or would you prefer to build completely from scratch? Source images are the most common route, but it can be nice to build from scratch if you have small, statically linked binaries.

2. Inside vs. Outside: Do you want to execute the commands to build the next container image layer inside the container, or would you prefer to use the tools on the host to build the image? This is completely new concept with Buildah, but with existing container engines, you always build from within the container. Building outside the container image can be useful when you want to build a smaller container image, or an image that will always be ran read only, and never built upon. Things like Java would normally be built in the container because they typically need a JVM running, but installing RPMs might happen from outside because you don't want the RPM database in the container.

3. External vs. Internal Data: Do you have everything you need to build the image from within the image? Or, do you need to access cached data outside of the build process? For example, It might be convenient to mount a large cached RPM cache inside the container during build, but you would never want to carry that around in the production image. The use cases for build time mounts range from SSH keys to Java build artifacts - for more ideas, see this [GitHub issue](https://github.com/moby/moby/issues/14080).

Alright, let's walk through some common scenarios with Buildah.

## Prep Work
Just like Podman, Buildah can execute in rootless mode, but since you have tools on the container host interacting files in the container image, you need to make Buildah think it's running as root. Buildah comes with a cool sub-command called unshare which does just this. It puts our shell into a user namespace just like when you have a root shell in a container. The difference is, this shell has access to tools installed on the container host, instead of in the container image. Before we complete the rest of this lab, execute the "buildah unshare" command. Think of this as making yourself root, without actually making yourself root:

``buildah unshare``{{execute}}

Now, look at who your shell thinks you are:

``whoami``{{execute}}

It's looks like you are root, but you really aren't, but let's prove it:

``touch /etc/shadow``{{execute}}

The touch command fails because you're not actually root. Really, the touch command executed as an arbitrary user ID in your /etc/subuid range. Let that sink in. Linux containers are mind bending. OK, let's do something useful.

## Basic Build

First declare what image you want to start with as a source. In this case, we will start with Red Hat Universal Base Image:

``buildah from ubi8``{{execute}}

This will create a "reference" to what Buildah calls a "working container" - think of them as a starting point to attach mounts and commands. Check it out here:

``buildah containers``{{execute}}

Now, we can mount the image source. In effect, this will trigger the graph driver to do its magic, pull the image layers together, add a working copy-on-write layer, and mount it so that we can access it just like any directory on the system:

``buildah mount ubi8-working-container``{{execute}}

Now, lets add a single file to the new container image layer. The Buildah mount command can be ran again to get access to the right directory:

``echo "hello world" > $(buildah mount ubi8-working-container)/etc/hello.conf``{{execute}}

Lets analyze what we just did. It's super simple, but kind of mind bending if you come from using other container engines. First, list the directory in the copy-on-write layer:

``ls -alh $(buildah mount ubi8-working-container)/etc/``{{execute}}

You should see hello.conf right there. Now, cat the file:

``cat $(buildah mount ubi8-working-container)/etc/hello.conf``{{execute}}``

You should see the text you expect. Now, lets commit this copy-on-write layer as a new image layer:

``buildah commit ubi8-working-container ubi8-hello``{{execute}}

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

``yum install --installroot $WORKING_MOUNT bash coreutils --releasever 8 --setopt install_weak_deps=false -y
yum clean all -y --installroot $WORKING_MOUNT --releasever 8``{{execute}}

Verify that some files have been added:

``ls -alh $WORKING_MOUNT``{{execute}}

Now, commit the copy-on-write layer as a new container image layer:

``buildah commit working-container minimal``{{execute}}

Now, test the new image layer, by creating a container:

``podman run -it minimal bash``{{execute}}

``exit``{{execute}}

Clean things up for our next experiment:

``buildah delete -a``{{execute}}

We have just created a container image layer from scratch without ever installing RPM or YUM. This same pattern can be used to solve countless problems. Makefiles often have the option of specifying the output directory, etc. This can be used to build a C program without ever installing the C toolchain in a container image layer. This is best for production security where we don't want the build tools laying around in the container.

## External Build Time Mounts

As a final example, lets use a build time mount to show how we can pull data in. This will represent some sort of cached data that we are using outside of the container. This could be a repository of Ansible Playbooks, or even Database test data:

``mkdir ~/data
dd if=/dev/zero of=~/data/test.bin bs=1MB count=100
ls -alh ~/data/test.bin``{{execute}}

Now, lets fire up a working container:

``buildah from ubi8
buildah mount ubi8-working-container``{{execute}}

To consume the data within the container, we use the buildah-run subcommand. Notice that it takes the -v option just like "run" in Podman. We also use the Z option to relabel the data for SELinux. The dd command simply represents consuming some smaller portion of the data during the build process:

``buildah run -v ~/data:/data:Z ubi8-working-container dd if=/data/test.bin of=/etc/small-test.bin bs=100 count=2``{{execute}}

Commit the new image layer and clean things up:

``buildah commit ubi8-working-container ubi8-data
buildah delete -a``{{execute}}

Test it and note that we only kept the pieces of the data that we wanted. This is just an example, but imagine using this with a Makefile cache, or Ansible playbooks, or even a copy of production database data which needs to be used to test the image build or do a schema upgrade, which must be accessed during the image build process. There are tons of places where you need to access data, only at build time, but don't want it during production deployment:

``podman run -it ubi8-data ls -alh /etc/small-test.bin``{{execute}}

## Cleanup

Exit the user namespace:

``exit``{{execute}}

## Conclusion

Now, you have a pretty good understanding of the cases where Buildah really shines. You can start from scratch, or use an existing image, use tools installed on the container host (not in the container image), and move data around as needed. This is a very flexible tool that should fit quite nicely in your tool belt. Buildah lets you script builds with any language you want, and build tiny images with only the bare minimum of utilities needed inside the image.

Now, lets move on to sharing containers with Skopeo...
