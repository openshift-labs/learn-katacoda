The goal of this exercise is to gain a basic understanding of how containers prevent using each other's reserved resources. The Linux kernel has a feature called cgroups (abbreviated from control groups) which limits, accounts for, and isolates the resource usage (CPU, memory, disk I/O, network, etc.) of processes. Normally, these control groups would be set up by a system administrator (with cgexec), or configured with systemd (systemd-run --slice), but with a container engine, this configuration is handled automatically.

To demonstrate, run two separate containerized sleep processes: 

`podman run -dt registry.access.redhat.com/ubi7/ubi sleep 10
podman run -dt registry.access.redhat.com/ubi7/ubi sleep 10
sleep 3
for i in $(podman ps | grep sleep | awk '{print $1}' | grep [0-9]); do find /sys/fs/cgroup/ | grep $i; done`{{execute}}

Notice how each containerized process is put into its own cgroup by the container engine. This is quite convenient, similar to sVirt.

