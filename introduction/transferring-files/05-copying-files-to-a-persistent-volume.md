If you are mounting a persistent volume into the container for your application and you need to copy files into it, then ``oc rsync`` can be used in the same way as described previously to upload files. All you need to do is supply as the target directory, the path of where the persistent volume is mounted in the container.

If you haven't as yet deployed your application, but are wanting to prepare in advance a persistent volume with all the data it needs to contain, you can still claim a persistent volume and upload the data to it. In order to do this, you will though need to deploy a dummy application against which the persistent volume can be mounted.

To create a dummy application for this purpose run the command:

``oc new-app centos/httpd-24-centos7 --name dummy``{{execute}}

We are using the Apache HTTPD server purely as a means of keeping the pod running, as well as creating a deployment configuration.

To monitor the startup of the pod and ensure it is deployed, run:

``oc rollout status deployment/dummy``{{execute}}

Now that we have a running application, we next need to claim a persistent volume and mount it against our dummy application. When doing this we assign it a claim name of ``data`` so we can refer to the claim by a set name later on. We mount the persistent volume at ``/mnt`` inside of the container, the traditional directory used in Linux systems for temporarily mounting a volume.

``oc set volume deployment/dummy --add --name=tmp-mount --claim-name=data --type pvc --claim-size=1G --mount-path /mnt``{{execute}}

This will cause a new deployment of our dummy application, this time with the persistent volume mounted. Again monitor the progress of the deployment so we know when it is complete, by running:

``oc rollout status deployment/dummy``{{execute}}

To confirm that the persistent volume claim was successful, you can run:

``oc get pvc``{{execute}}

With the dummy application now running, and with the persistent volume mounted, capture the name of the pod for the running application.

``POD=`pod deployment=dummy`; echo $POD``{{execute}}

We can now copy any files into the persistent volume, using the ``/mnt`` directory where we mounted the persistent volume, as the target directory. In this case since we are doing a one off copy, we can use the ``tar`` strategy instead of the ``rsync`` strategy.

``oc rsync ./ $POD:/mnt --strategy=tar``{{execute}}

When complete, you can validate that the files were transferred by listing the contents of the target directory inside of the container.

``oc rsh $POD ls -las /mnt``{{execute}}

If you were done with this persistent volume and perhaps needed to repeat the process with another persistent volume and with different data, you can unmount the persistent volume but retain the dummy application.

``oc set volume deployment/dummy --remove --name=tmp-mount``{{execute}}

Monitor the process once again to confirm the re-deployment has completed.

``oc rollout status deployment/dummy``{{execute}}

Capture the name of the current pod again:

``POD=`pod deployment=dummy`; echo $POD``{{execute}}

and look again at what is in the target directory. It should be empty at this point. This is because the persistent volume is no longer mounted and you are looking at the directory within the local container file system.

``oc rsh $POD ls -las /mnt``{{execute}}

If you already have an existing persistent volume claim, as we now do, you could mount the existing claimed volume against the dummy application instead. This is different to above where we both claimed a new persistent volume and mounted it to the application at the same time.

``oc set volume deployment/dummy --add --name=tmp-mount --claim-name=data --mount-path /mnt``{{execute}}

Look for completion of the re-deployment:

``oc rollout status deployment/dummy``{{execute}}

Capture the name of the pod:

``POD=`pod deployment=dummy`; echo $POD``{{execute}}

and check the contents of the target directory. The files we copied to the persistent volume should again be visible.

``oc rsh $POD ls -las /mnt``{{execute}}

When done and you want to delete the dummy application, use ``oc delete`` to delete it, using a label selector of ``deployment=dummy`` to ensure we only delete the resource objects related to the dummy application.

``oc delete all --selector deployment=dummy``{{execute}}

Check that all the resource objects have been deleted.

``oc get all --selector deployment=dummy -o name``{{execute}}

Although we have deleted the dummy application, the persistent volume claim still exists and can later be mounted against your actual application to which the data belongs.

``oc get pvc``{{execute}}
