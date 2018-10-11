The goal of this lab is to introduce you to Podman and some of the features that make it interesting. If you have ever used Docker, the basics should be pretty familiar. Lets start with some simple commands.

List images:

Start a container:

List running containers:

Stop all containers:

Remove all images:

Now, lets analyse a couple of intersting things that makes Podman different than Docker. First, it doesn't use a client server model:

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
