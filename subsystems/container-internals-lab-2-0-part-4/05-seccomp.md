The goal of this exercise is to gain a basic understanding of SECCOMP. Think of a SECCOMP as a firewall which can be configured to block certain system calls.  While optional, and not configured by default, this can be a very powerful tool to block misbehaved containers. Take a look at this sample:

`cat ~/labs/lab3-step5/chmod.json`{{execute}}


Now, run a container with this profile and test if it works. 

`podman run -it --security-opt seccomp=./labs/lab3-step5/chmod.json registry.access.redhat.com/ubi7/ubi chmod 777 /etc/hosts`{{execute}}

Notice how the chmod system call is blocked.
