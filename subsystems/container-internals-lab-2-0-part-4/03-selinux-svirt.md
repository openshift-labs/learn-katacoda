The goal of this exercise is to gain a basic understanding of SELinux/sVirt. Run the following commands:

`podman run -dt registry.access.redhat.com/ubi7/ubi sleep 10
podman run -dt registry.access.redhat.com/ubi7/ubi sleep 10
sleep 3
ps -efZ | grep container_t | grep sleep`{{execute}}


Example Output:

``system_u:system_r:container_t:s0:c228,c810 root 18682 18669  0 03:30 pts/0 00:00:00 sleep 10
system_u:system_r:container_t:s0:c184,c827 root 18797 18785  0 03:30 pts/0 00:00:00 sleep 10``

Notice that each container is labeled with a dynamically generated [Multi Level Security (MLS)](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/mls) label. In the example above, the first container has an MLS label of c228,c810 while the second has a label of c184,c827. Since each of these containers is started with a different MLS label, they are prevented from accessing each other's memory, files, etc.

SELinux doesn't just label the processes, it must also label the files accessed by the process. Make a directory for data, and inspect the SELinux label on the directory. Notice the type is set to "user_tmp_t" but there are no MLS labels set:

`mkdir /tmp/selinux-test`{{execute}}

`ls -alhZ /tmp/selinux-test/`{{execute}}


Example Output:

``drwxr-xr-x. root root system_u:object_r:container_file_t:s0:c177,c734 .
drwxrwxrwt. root root system_u:object_r:tmp_t:s0       ..``


Now, run the following command a few times and notice the MLS labels change every time. This is sVirt at work:

`podman run -t -v /tmp/selinux-test:/tmp/selinux-test:Z registry.access.redhat.com/ubi7/ubi ls -alhZ /tmp/selinux-test`{{execute}}


Finally, look at the MLS label set on the directory, it is always the same as the last container that was run. The :Z option auto-labels and bind mounts so that the container can access and change files on the mount point. This prevents any other process from accessing this data and is done transparently to the end user.

`ls -alhZ /tmp/selinux-test/`{{execute}}
