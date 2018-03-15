The goal of this exercise is to gain a basic understanding of cgroups. Run two separate containerized sleep processes. Notice how each are put in their own cgroups. Copy and paste all four lines below, into a terminal:

``docker run -t rhel7 sleep 10 &
docker run -t rhel7 sleep 10 &
sleep 3
for i in `docker ps | grep sleep | awk '{print $1}' | grep [0-9]`; do find /sys/fs/cgroup/ | grep $i; done``{{execute}}
