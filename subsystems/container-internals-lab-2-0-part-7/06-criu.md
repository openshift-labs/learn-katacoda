With some help from a program called CRIU, Podman can checkpoint and restore containers on the same host. This can be useful with workloads that have a long startup period or require a long time to warm up caches. For example, large memcached servers, database, or even Java workloads can take several minutes or even hours to reach maximum throughput performance. This is often referred to as cache warming.

If this doesn't quite make sense, let's talk about it in the context of container creation and deletion. Podman allow you to break the creation and deletion of containers down into very granular steps. Here's what the life cycle of a container looks like from start to finish:

1. podman pull - Pull the container image
2. podman create - Add tracking meta-data to /var/lib/containers or .local/share/containers
3. podman mount - Create a copy-on-write layer and mount the container image with a read/write layer above it
4. podman init - Create a config.json file
5. podman start - Run the workload by handing the config.json and root file system to runc
6. Workload runs either as a batch process, or as a daemon
7. podman kill - kills the process or processes in the container
8. podman rm - Unmount and delete the copy-on-write layer
9. podman rmi - remove the image /var/lib/containers or .local/share/containers

To understand CRIU, you need to understand step 6. When this step is executed, Podman sends a kill signal to the processes in the container. CRIU allows us to break this down even further like this:


1. podman pull - Pull the container image
2. podman create - Add tracking meta-data to /var/lib/containers or .local/share/containers
3. podman mount - Create a copy-on-write layer and mount the container image with a read/write layer above it
4. podman init - Create a config.json file
5. podman start - Run the workload by handing the config.json and root file system to runc
6. Workload runs either as a batch process, or as a daemon
7. podman checkpoint - Dump contents of memory to disk and kill processes
8. Workload process no longer running, memory contents are saved on disk
9. podman restore - Restore memory contents to new processes
10. Workload runs either as a batch process, or as a daemon
11. podman kill - kills the process or processes in the container
12. podman rm - Unmount and delete the copy-on-write layer
13. podman rmi - remove the image /var/lib/containers or .local/share/containers

So, in a nutshell, CRIU gives you more flexibility with containerized processes. Let's see it in action. First, start a simple container which generates incrementing numbers so that we can verify memory contents are really restored:

``podman run -d --name looper busybox /bin/sh -c \
         'i=0; while true; do echo $i; i=$(expr $i + 1); sleep 1; done'``{{execute}}

Now, verify that numbers are being generated:

``podman logs -l``{{execute}}

Now, let's dump the contents of memory to disk, and kill the process:

``podman container checkpoint -l``{{execute}}

Verify that it's not running:

``podman ps -a``{{execute}}

Verify that numbers are not being generated:

``podman logs -l``{{execute}}

Restore the container:

``podman container restore -l``{{execute}}

Now, verify that numbers are being generated:

``podman logs -l``{{execute}}

Clean up:

``podman kill -a``{{execute}}

Now, let's move on to some more tools.
