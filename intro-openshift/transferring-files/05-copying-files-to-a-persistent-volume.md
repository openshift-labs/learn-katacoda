If you are mounting a persistent volume into the container for your application and you need to copy files into it, then ``oc rsync`` can be used in the same way as described previously to upload files. All you need to do is supply as the target directory, the path of where the persistent volume is mounted in the container.

If you haven't as yet deployed your application, but are wanting to prepare in advance a persistent volume with all the data it needs to contain, you can still claim a persistent volume and upload the data to it. In order to do this, you will though need to deploy a temporary application against which the persistent volume can be mounted.

``oc run dummy --image centos/httpd-24-centos7``{{execute}}

``oc rollout status dc/dummy``{{execute}}

``oc set volume dc/dummy --add --name=tmp-mount --claim-name=data --type pvc --claim-size=1G --mount-path /mnt``{{execute}}

``oc rollout status dc/dummy``{{execute}}

``oc get pvc``{{execute}}

``POD=`oc get pods --selector run=dummy -o custom-columns=name:.metadata.name --no-headers`; echo $POD``{{execute}}

``oc rsync ./ $POD:/mnt --strategy=tar``{{execute}}

``oc rsh $POD ls -las /mnt``{{execute}}

``oc set volume dc/dummy --remove --name=tmp-mount``{{execute}}

``oc rollout status dc/dummy``{{execute}}

``oc set volume dc/dummy --add --name=tmp-mount --claim-name=data --mount-path /mnt``{{execute}}

``oc rollout status dc/dummy``{{execute}}

``POD=`oc get pods --selector run=dummy -o custom-columns=name:.metadata.name --no-headers`; echo $POD``{{execute}}

``oc rsh $POD ls -las /mnt``{{execute}}

``oc delete all --selector run=dummy``{{execute}}

``oc get pvc``{{execute}}
