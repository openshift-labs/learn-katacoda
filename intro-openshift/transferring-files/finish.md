In this course you learnt about ``oc`` commands you can use to transfer files to and from a running container, as well as how to set up live synchronization so changes are automatically copied from a local machine into a running container.

You can find a summary of the key commands covered below. To see more information on each ``oc`` command, run it with the ``--help`` option.

``oc rsync <pod-name>:/remote/dir/filename ./local/dir``: Copy a single file from the pod to the local directory.

``oc rsync <pod-name>:/remote/dir ./local/dir``: Copy the  directory from the pod to the local directory.

``oc rsync <pod-name>:/remote/dir/. ./local/dir``: Copy the contents of the directory from the pod to the local directory.

``oc rsync <pod-name>:/remote/dir ./local/dir --delete``: Copy the contents of the directory from the pod to the local directory. The ``--delete`` option ensures that the resulting directories will match exactly, with directories/files in the local directory which are not found in the pod being deleted.

``oc rsync ./local/dir <pod-name>:/remote/dir --no-perms``: Copy the directory to the remote directory in the pod. The ``--no-perms`` option ensures that no attempt is made to transfer permissions, which can fail if remote directories are not owned by user container runs as.

``oc rsync ./local/dir <pod-name>:/remote/dir --exclude=* --include=<filename> --no-perms``: Copy the single file to the remote directory in the pod. The ``--no-perms`` option ensures that no attempt is made to transfer permissions, which can fail if remote directories are not owned by user container runs as.

``oc rsync ./local/dir <pod-name>:/remote/dir --no-perms --watch``: Copy the directory to the remote directory in the pod and then keep the remote directory syncrhonized with the local directory, with any changed files automatically being copied to the pod. The ``--no-perms`` option ensures that no attempt is made to transfer permissions, which can fail if remote directories are not owned by user container runs as. The ``--watch`` option is what enables the synchronization mechanism.

``oc run dummy --image centos/httpd-24-centos7``: Run a dummy application pod which can be used to mount persistent volumes to facilitate copying files to a persistent volume.

``oc set volume dc/dummy --add --name=tmp-mount --claim-name=<claim-name> --type pvc --claim-size=1G --mount-path /mnt``: Claim a persistent volume and mount it against a dummy application pod at the directory ``/mnt`` so files can be copied into the persistent volume using ``oc rsync``.

``oc set volume dc/dummy --add --name=tmp-mount --claim-name=<claim-name> --mount-path /mnt``: Mount an existing persistent volume against a dummy application pod at the directory ``/mnt`` so files can be copied into the persistent volume using ``oc rsync``.

``oc rsync ./local/dir <pod-name>:/remote/dir --strategy=tar``: Copy the directory to the remote directory in the pod. The ``--strategy=tar`` option indicates to use ``tar`` to copy the files rather than ``rsync``.
