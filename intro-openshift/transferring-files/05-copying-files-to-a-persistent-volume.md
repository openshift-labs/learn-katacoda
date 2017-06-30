If you are mounting a persistent volume into the container for your application and you need to copy files into it, then ``oc rsync`` can be used in the same way as described previously, to upload files into the container. All you need to do is supply as the target directory, the path of where the persistent volume is mounted.

If you haven't as yet deployed your application, but are wanting to prepare in advance a persistent volume with all the data it needs to contain, you can still claim a persistent volume and upload the data to it. In order to do this, you will though need to deploy a temporary application against which the persistent volume can be mounted.

``oc run dummy --image busybox --command -- watch -n 60 date``{{execute}}

``oc set volume dc/dummy --add --claim-name=data --type pvc --claim-size=1G --mount-path /home``{{execute}}

``oc get pvc``{{execute}}

``POD=`oc get pods --selector run=dummy -o custom-columns=name:.metadata.name --no-headers`; echo $POD``{{execute}}

``oc rsync ./ $POD:/home --no-perm``{{execute}}

``oc rsh $POD ls -las /home``{{execute}}

``oc delete all --selector run=dummy``{{execute}}

``oc get pvc``{{execute}}
