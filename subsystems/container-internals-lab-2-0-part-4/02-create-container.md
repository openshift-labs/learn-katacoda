In this step, we are going to investigate the basic construction of a container. The general contruction of a container is similar with almost all OCI compliant container engines:

1. Pull/expand/mount image
2. Create OCI compliant spec file
3. Call runc with the spec file


## Pull/Expand/Mount Image

Let's use podman to create a container from scratch. Podman makes it easy to break down each step of the container construction for learning purposes. First, let's pull the image, expand it, and create a new overlay filesystem layer as the read/write root filesystem for the container. To do this, we will use a specially constructed container image which lets us break down the steps instead of starting all at once:

`podman create -dt --name on-off-container -v /mnt:/mnt:Z quay.io/fatherlinux/on-off-container`{{execute}}

After running the above command we have storage created. Notice under the STATUS column, the container is the "Created" state. This is not a running container, just the first step in creation has been executed:

`podman ps -a`{{execute}}

Try to look at the storage with the mount command (hint, you won't be able to find it):

`mount | grep -v docker | grep merged`{{execute}}

Hopefully you didn't look for too long because you can't see it with the mount command. That's because this storage has been "mounted" in what's called a mount namespace. You can only see the mount from inside the container. To see the mount from outside the container, podman has a cool feature called podman-mount. This command will return the path of a directory which you can poke around in:

`podman mount on-off-container`{{execute}}

The directory you get back is a system level mount point into the overlay filesystem which is used by the container. You can literally change anything in the container's filesystem now. Run a few commands to poke around:

`mount | grep -v docker | grep merged`{{execute}}

`ls $(podman mount on-off-container)`{{execute}}

`touch $(podman mount on-off-container)/test`{{execute}}

`ls $(podman mount on-off-container)`{{execute}}

See the test file there. You will see this file in our container later when we start it and create a shell inside of it. Let's move on to the spec file...

## Create Spec File

At this point the container image has been cached locally and mounted, but we don't actually have a spec file for runc yet. Creating a spec file from hand is quite tedious because they are made up of complex JSON with a lot of different options (governed by the OCI runtime spec). Luckily for us, the container engine will create one for us. This exact same spec file can be used by any OCI compliant runtime can consume it (runc, crun, katacontainers, gvisor, etc). Let's run some experiments to show when it's created. First let's inspect the place where it should be:

`cat /var/lib/containers/storage/overlay-containers/$(podman ps -l -q --no-trunc)/userdata/config.json|jq .`{{execute}}

The above command errors out because the container engine hasn't created the config.json file yet. We will initiate the creation of this file by using podman combined with a specially constructed container image:

`podman start on-off-container`{{execute}}

Now, the config.json file has been created. Inspect it for a while. Notice that there are options in there that are strikingly similar to the command line options of podman. The spec file really highlights the API:

`cat /var/lib/containers/storage/overlay-containers/$(podman ps -l -q --no-trunc)/userdata/config.json|jq .`{{execute}}

Podman has not started a container, just created the config.json and immediately exited. Notice under the STATUS column, that the container is now in the Exited state:

`podman ps -a`{{execute}}

In the next step, we will create a running container with runc...

## Call Runtime

Now that we have storage and a config.json, let's complete the circuit and create a containerized process with this config.json. We have constructed a container image, which only starts a process in the container if the /mnt/on file exists. Let's create the file, and start the container again:

`touch /mnt/on`{{execute}}

`podman start on-off-container`{{execute}}

When podman started the container this time, it fired up top. Notice under the STATUS column, that the container is now in the Up state::

`podman ps -a`{{execute}}

Now, let's fire up a shell inside of our running container:

`podman exec -it on-off-container bash`{{execute}}

Now, look for the test file we created before we started the container:

`ls -alh`{{execute}}

The file is there like we would expect. You have just created a container in three basic steps. Did you know and understand that all of this was happening every time you ran a podman or docker command? Now, clean up your work:

`exit`{{execute}}

`podman kill -a
podman rm -a`{{execute}}
