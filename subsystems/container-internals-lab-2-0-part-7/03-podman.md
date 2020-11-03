The goal of this lab is to introduce you to Podman and some of the features that make it interesting. If you have ever used Docker, the basics should be pretty familiar. Lets start with some simple commands.

Pull an image:

``podman pull ubi8``{{execute}}

List locally cached images:

``podman images``{{execute}}

Start a container and run bash interactively in the local terminal. When ready, exit:

``podman run -it ubi8 bash``{{execute}}

``exit``{{execute}}

List running containers: 

``podman ps -a``{{execute}}

Now, let's move on to some features that differentiates Podman from Docker. Specifically, let's cover the two most popular reasons - Podman runs with a daemon (daemonless) and without root (rootless). Podman does not have a daemon, it's an interactive command more like bash, and like bash it can be run as a regular user (aka. rootless).

The container host we are working with already has a user called RHEL, so let's switch over to it. Note, we set a couple of environment variables manually because we're using the switch user command. These would normally be set at login:

``su - rhel
export XDG_RUNTIME_DIR=/home/rhel``{{execute}}

Now, fire up a simple container in the background:

``podman run -id ubi8 bash``{{execute}}

Now, lets analyze a couple of interesting things that makes Podman different than Docker - it doesn't use a client server model, which is useful for wiring it into CI/CD systems, and other schedulers like Yarn:

Inspect the process tree on the system: 

``pstree -Slnc``{{execute}}

You should see something similar to:

``└─conmon─┬─{conmon}
         └─bash(ipc,mnt,net,pid,uts)``

There's no Podman process, which might be confusing. Lets explain this a bit. What many people don't know is that containers disconnect from Podman after they are started. Podman keeps track of meta-data in ~/.local/share/containers (/var/lib/containers is only used for containers started by root) which tracks which containers are created, running, and stopped (killed). The meta-data that Podman tracks is what enables a "podman ps" command to work. 

In the case of Podman, containers disconnect from their parent processes so that they don't die when Podman exit exits. In the case of Docker and CRI-O which are daemons, containers disconnect from the parent process so that they don't die when the daemon is restarted. For Podman and CRI-O, there is utility which runs before runc called conmon (Container Monitor). The conmon utility disconnects the container from the engine by doing forking twice (called a double fork). That means, the execution chain looks something like this with Podman:

``bash -> podman -> conmon -> conmon -> runc -> bash``

Or like this with CRI-O:

``systemd -> crio -> conmon -> conmon -> runc -> bash``

Or like this with Docker engine:

``systemd -> dockerd -> containerd -> docker-shim -> runc -> bash``

Conmon is a very small C program that monitors the standard in, standard error, and standard out of the containerized process. The conmon utility and docker-shim both serve the same purpose. When the first conmon finishes calling the second, it exits. This disconnects the second conmon and all of its child processes from the container engine. The second conmon then inherits init system (systemd) as its new parent process. This daemonless and simplified model which Podman uses can be quite useful when wiring it into other larger systems, like CI/CD, scripts, etc.

Podman doesn't require a daemon and it doesn't require root. These two features really set Podman apart from Docker. Even when you use the Docker CLI as a user, it connects to a daemon running as root, so the user always has the ability escalate a process to root and do whatever they want on the system. Worse, it bypasses sudo rules so it's not easy to track down who did it.

Now, let's move on to some other really interesting features. Rootless containers use a kernel feature called User Namespaces. This maps the one or more user IDs in the container to one or more user IDs outside of the container. This includes the root user ID in the container as well as any others which might be used by programs like Nginx or Apache.

Podman makes it super easy to see this mapping. Start an nginx container to see the user and group mapping in action:


``podman run -id registry.access.redhat.com/rhscl/nginx-114-rhel7 nginx -g 'daemon off;'``{{execute}}

Now, execute the Podman bash command:

``podman top -l args huser hgroup hpid user group pid seccomp label``{{execute}}

Notice that the host user, group and process ID  ''in'' the container all map to different and real IDs on the host system. The container thinks that nginx is running as the user ''default'' and the group ''root'' but really it's running as an arbitrary user and group. This user and group are selected from a range configured for the ''rhel'' user account on this system. This list can easily be inspected with the following commands:

``cat /etc/subuid``{{execute}}

You will see something similar to this:

``rhel:165536:65536``

The first number represents the starting user ID, and the second number represents the number of user IDs which can be used from the starting number. So, in this example, our RHEL user can use 65,535 user IDs starting with user ID 165536. The Podman bash command should show you that nginx is running in this range of UIDs.

The user ID mappings on your system might be different because shadow utilities (useradd, usderdel, usermod, groupadd, etc) automatically creates these mappings when a user is added. As a side note, if you've updated from an older version of RHEL, you might need to add entries to /etc/subuid and /etc/subgid manually.

OK, now stop all of the running containers. No more one liners like with Docker, it's just built in with Podman:

``podman kill --all``{{execute}}

Remove all of the actively defined containers. It should be noted that this might be described as deleting the copy-on-write layer, config.json (commonly referred to as the Config Bundle) as well as any state data (whether the container is defined, running, etc):

``podman rm --all``{{execute}}

We can even delete all of the locally cached images with a single command:

``podman rmi --all``{{execute}}

The above commands show how easy and elegant Podman is to use. Podman is like a Chef's knife. It can be used for pretty much anything that you used Docker for, but let's move on to Builah and show some advanced use cases when building container images.
