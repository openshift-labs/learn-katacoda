The goal of this exercise is to gain a basic understanding of SELinux/sVirt. Run the following commands. Notice that each container is labeled with a dynamically generated MLS label. In the example below, the first container has an MLS label of c791,c940, while the second has a label of c169,c416. This extra layer of labeling prevents the processes from accessing each other's memory, files, etc. Copy and paste all four lines below, into a terminal:

``docker run -t rhel7 sleep 10 &
docker run -t rhel7 sleep 10 &
sleep 3
ps -efZ | grep svirt | grep sleep``{{execute}}


Output:

``system_u:system_r:svirt_lxc_net_t:s0:c791,c940 root 54810 54796  1 00:40 pts/7 00:00:00 sleep 10
system_u:system_r:svirt_lxc_net_t:s0:c169,c416 root 54872 54858  1 00:40 pts/8 00:00:00 sleep 10``


SELinux doesn't just label the processes, it must also label the files accessed by the process. Make a directory for data, and inspect the selinux label on the directory. Notice the type is set to "user_tmp_t" but there are no MLS labels set:

``mkdir /tmp/selinux-test``{{execute}}

``ls -alhZ /tmp/selinux-test/``{{execute}}


Output:

``drwxr-xr-x. root root unconfined_u:object_r:user_tmp_t:s0 .
drwxrwxrwt. root root system_u:object_r:tmp_t:s0       ..``


Now, run the following command a few times and notice the MLS labels change every time. This is sVirt at work:

``docker run -t -v /tmp/selinux-test:/tmp/selinux-test:Z rhel7 ls -alhZ /tmp/selinux-test``{{execute}}


Output:

``drwxr-xr-x. root root system_u:object_r:svirt_sandbox_file_t:s0:c395,c498 .
drwxrwxrwt. root root system_u:object_r:svirt_sandbox_file_t:s0:c395,c498 ..``


Look at the MLS label set on the directory, it is always the same as the last container that was run. The :Z option auto-labels and bind mounts so that the container can acess and change files in the mount. This prevents any other process from accessing this data. It's done transparently to the end user.

``ls -alhZ /tmp/selinux-test/``{{execute}}

