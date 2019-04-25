In this step, we are going to investigate the basic construction of a container. The general contruction of a container is similar with almost all OCI compliant container engines:

1. Pull/expand/mount image
2. Create OCI compliant spec file
3. Call runc with the spec file


## Pull/Expand/Mount Image

Let's create a container from scratch and investigate each step using podman. Podman makes it easy to break down each step of the construction for learning. First, let's pull the image, expand it, and create a new overlay layer for read/write in the container:

`podman create -dt --name on-off-container -v /mnt:/mnt:Z registry.access.redhat.com/ubi7/ubi bash -c 'if [ -f /mnt/on ]; then top; fi'`{{execute}}

OK, we have storage created. Notice the "Created" status of the container:

`podman ps -a`{{execute}}

Try to look at the storage with the mount command (hint, you won't be able to find it):

`mount`{{execute}}

OK, hopefully you didn't look for too long, because you can't see it with the mount command. That's because this storage has been "mounted" in what's called a mount namespace. To see the storage from outside the container, podman has a cool feature called podman-mount. Let's play with it a hair:

`podman mount on-off-container`{{execute}}

The directory you get back is a system level mount point into the overlay filesystem which is used by the container. You can literally change anything in the container's filesystem now. Run a few commands to poke around:

`mount`{{execute}}
`ls $(podman mount on-off-container)`{{execute}}
`touch $(podman mount on-off-container)/test`{{execute}}
`ls $(podman mount on-off-container)`{{execute}}

See the test file there. That would be in our container, should we fire it up. OK, we have storage, let's move on to the spec file...

## Create Spec File

At this point the container image has been cached locally and mounted, but we don't actually have a spec file for runc yet. The container engine will automatically create this, and any OCI compliant runtime can consume it (runc, crun, katacontainers, gvisor, etc). Let's run some experiments to show when it's created. We will use some simple bash scripting to get at the config.json (spec file passed to runc) file as it's created by podman:

`tail /var/lib/containers/storage/overlay-containers/$(podman ps -l -q --no-trunc)/userdata/config.json|jq .`{{execute}}
`podman start on-off-container`{{execute}}
`tail /var/lib/containers/storage/overlay-containers/$(podman ps -l -q --no-trunc)/userdata/config.json|jq .`{{execute}}

We used the -l (last container run) option to get the container ID, then used it as the directory name under /var/lib/containers/storage. This is the location for all of the storage with podman, CRI-O, buildah, etc. We also used the jq command to prettify the JSON in the spec file. Notice the spec file was not created until we actually started the container. Since we never passed the container a "command" to run, it immediatedly exited:

`podman ps -l`{{execute}}

Now, let's delete our storage and config.json

`podman kill -l
podman rm -l`{{execute}}

OK, let's move on to calling runc...

## Call Runtime

Now that we have storage and a config.json, let's complete the circuit and create a containerized process with this config.json. We have wired the command passed to this container, to only start top if the file /mnt/on exists. Once we create the file, it gets passed through to the container, and read on start:

`touch /mnt/on`
`podman start on-off-container`{{execute}}

This time it's in the running state:

`podman ps -l`{{execute}}

This time, let's start the container and let it run:

`podman start on-off-container`{{execute}}

This time it's runnig the top command:

`podman ps -l`{{execute}}

The config.json file has been created as we would expect:

`tail /var/lib/containers/storage/overlay-containers/$(podman ps -l -q --no-trunc)/userdata/config.json|jq .`{{execute}}

And, we 

We have storage, and we have a config.json file, now we can have the container engine, podman, fire up runc, or we can do it ourselve manually.



The container image has been used as a base layer, and an overlay layer has been created. Check out the volume with the podman mount command:

podman mount on-off-container



podman exec -it on-off-container bash
