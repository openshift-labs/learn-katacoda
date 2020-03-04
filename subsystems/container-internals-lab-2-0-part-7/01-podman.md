The goal of this lab is to introduce you to Podman and some of the features that make it interesting. If you have ever used Docker, the basics should be pretty familiar. Lets start with some simple commands.

Pull an image:

``podman pull fedora``{{execute}}

List locally cached images:

``podman images``{{execute}}

Start a container and run bash interactively in the local terminal. When ready, exit:

``podman run -it fedora bash``{{execute}}

``exit``{{execute}}

List running containers: 

``podman ps -a``{{execute}}

Advanced list of running containers. This is much more robust than what most tools can do and quite useful when using User Namespaces. First, create a running container. Then, inspect notice the USER, GROUP, HPID (host process identifier), SECCOMP, and LABEL fields. Very cool stuff:

``podman run -dt fedora bash``{{execute}}

``podman top -l args user group pid hpid seccomp label``{{execute}}

You should see output similar to the following. Notice the USER, GROUP, HPID (host process identifier), SECCOMP, and LABEL fields. Very cool stuff:

``COMMAND   USER   GROUP   PID   HPID   SECCOMP   LABEL
bash      root   root    1     ?      filter    system_u:system_r:container_t:s0:c24,c154``

Now, stop all of the running containers. No more one liners, it's just built in with Podman:

``podman stop --all``{{execute}}

Remove all of the actively defined containers. It should be noted that this might be described as deleting the copy-on-write layer, config.json (commonly referred to as the Config Bundle) as well as any state data (whether the container is defined, running, etc):

``podman rm --all``{{execute}}

We can even delete all of the locally cached images with a single command:

``podman rmi --all``{{execute}}

The above commands show how easy and elegant podman is to use. Now, lets analyse a couple of intersting things that makes Podman different than Docker - it doesn't use a client server model, which is useful for wiring it into CI/CD systems, and other schedulers like Yarn:

## Terminal 1

Cache the Fedora Toolbox image:

``podman pull registry.fedoraproject.org/f29/fedora-toolbox``{{execute}}

Wait for the image pull to complete, then move on...

## Terminal 2

In a second terminal (plus sign), run a container:

``podman run -it fedora-toolbox top``{{execute}}


## Terminal 1

Inspect the process tree on the system: 

``pstree -Slnc``{{execute}}

You should see something similar to:

``├─sshd─┬─sshd───bash
│      ├─sshd───bash───pstree
│      ├─sshd───bash
│      ├─sshd
│      ├─sshd───podman─┬─{podman}``

and:

``└─conmon─┬─{conmon}
         └─top(ipc,mnt,net,pid,uts)``

Lets explain this a bit. What many people don't know is that the container disconnects from the parent process. This is done so that the running containers don't die when the engine exits (Podman doesn't run as a daemon) or is restarted (CRI-O daemon, Docker Engine). There is utility that runs between podman and runc called conmon (Container Monitor). The connmon utility disconnects the container from the engine by doing a double fork(). That means, the execution chain looks something like this with Podman:

``bash -> podman -> conmon -> conmon -> runc -> bash``

Or like this with CRI-O:

``systemd -> crio -> conmon -> conmon -> runc -> bash``

Or like this with Docker engine:

``systemd -> dockerd -> containerd -> docker-shim -> runc -> bash``

The conmon utility and docker-shim both serve the same purpose. When the first conmon finishes calling the second, it exits. This disconnects the second conmon and all of its child processes from the container engine, podman. The secondary conmon is then inherited by init (systemd), the first process running on when the system boots. This simplified, daemonless model with podman can be quite useful when wiring it into other larger systems, like CI/CD, scripts, etc.

Alright, now that we know how to run containers, lets move on to building...
