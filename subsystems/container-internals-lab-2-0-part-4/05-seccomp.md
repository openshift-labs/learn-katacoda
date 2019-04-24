The goal of this exercise is to gain a basic understanding of SECCOMP. Take a look at this sample. This can be a very powerful tool to block malbehaved containers:

``cat ~/labs/lab3-step5/chmod.json``{{execute}}


Now, run a container with this profile and test if it works. Notice how the chmod system call is blocked.

``podman run -it --security-opt seccomp:./labs/lab3-step5/chmod.json registry.access.redhat.com/ubi7/ubi chmod 777 /etc/hosts``{{execute}}

