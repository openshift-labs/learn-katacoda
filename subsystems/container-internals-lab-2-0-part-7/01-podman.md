The goal of this lab is to introduce you to Podman and some of the features that make it interesting. If you have ever used Docker, the basics should be pretty familiar. Lets start with some simple commands.

Pull an image:

``podman pull fedora``{{execute}}

List locally cached images:

``podman images``{{execute}}

Start a container and run bash interactively in the local terminal. When ready, exit:

``podman run -it fedora bash``{{execute}}

``exit``{{execute}}

List running containers: 

``podman ps -ef``{{execute}}

Advanced list of running containers. This is much more robust than what most tools can do and quite useful when using User Namespaces. First, create a running container. Then, inspect notice the USER, GROUP, HPID (host process identifier), SECCOMP, and LABEL fields. Very cool stuff:

``podman run -dt fedora bash``{{execute}}

``podman top -l args user group pid hpid seccomp label``{{execute}}

You should see output similar to the following. Notice the USER, GROUP, HPID (host process identifier), SECCOMP, and LABEL fields. Very cool stuff:

``COMMAND   USER   GROUP   PID   HPID   SECCOMP   LABEL
bash      root   root    1     ?      filter    system_u:system_r:container_t:s0:c24,c154``

Now, stop all of the running containers. No more one liners, it's just built in with Podman:

``podman stop -all``{{execute}}

Delete all of the actively defined containers. It should be noted that this might be described as deleted the copy-on-write layer, config.json (commonly referred to as the Config Bundle) as well as any state data (whether the container is defined, running, etc):

``podman delete -all``{{execute}}

We can even delete all of the locally cached images with a single command:

``podman rmi -all``{{execute}}

The above commands show how easy and elegant podman is to use. Now, lets analyse a couple of intersting things that makes Podman different than Docker. First, it doesn't use a client server model:

## Terminal 2

Run a container:

``podman run -it centos top``{{execute}}


##Terminal 1

pstree 
``pstree -Slnc``{{execute}}

You should see something similar to:

``├─sshd─┬─sshd───sshd───bash───podman───11*[{podman}]
        │      ├─sshd───sshd───bash───pstree
        │      └─sshd───sshd───bash───podman───10*[{podman}]``

and:

``├─conmon─┬─{conmon}
        │        └─bash(ipc,mnt,net,pid,uts)───top
        └─conmon─┬─{conmon}
                 └─top(ipc,mnt,net,pid,uts) ``

Lets explain this a bit. What many people don't know is that the container disconnects from the parent process. This is done so that the running containers don't die when the engine exits (Podman doesn't run as a daemon) or is restarted (CRI-O daemon, Docker Engine). There is utility that runs between podman and runc called conmon (Container Monitor). The connmon utility disconnects the container from the engine by doing a double fork(). That means, the execution chain looks something like this with Podman:

``bash -> podman -> conmon -> conmon -> runc -> bash``

Or like this with CRI-O:

``systemd -> crio -> conmon -> conmon -> runc -> bash``

Or like this with Docker engine:

``systemd -> dockerd -> containerd -> docker-shim -> runc -> bash``

The conmon utility and docker-shim both serve the same purpose. When the first conmon finishes calling the second, it exits. This disconnects the second conmon and all of its chil processes from the container engine, podman. The secondary conmon is then inherited by init (systemd), the first process running on when the system boots.

Alright, now that we know how to run containers, lets move on to building...
