When a deployment is defined, it can assign itself to a previous claim. The following snippet defines a volume mount for the directory _/var/lib/mysql/data_ which is mapped to the storage _mysql-persistent-storage_. The storage called _mysql-persistent-storage_ is mapped to the claim called _claim-mysql_.

<pre>
  spec:
      volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql/data
  volumes:
    - name: mysql-persistent-storage
      persistentVolumeClaim:
        claimName: claim-mysql
</pre>

## Task

Launch two new Pods with Persistent Volume Claims. Volumes are mapped to the correct directory when the Pods start allowing applications to read/write as if it was a local directory.

`oc create -f pod-mysql.yaml`{{execute}}

`oc create -f pod-www.yaml`{{execute}}

Use the command below to view the definition of the Pods.

`cat pod-mysql.yaml pod-www.yaml`{{execute}}

You can see the status of the Pods starting using `oc get pods`{{execute}}

If a Persistent Volume Claim is not assigned to a Persistent Volume, then the Pod will be in _Pending_ mode until it becomes available. In the next step, we'll read/write data to the volume.
