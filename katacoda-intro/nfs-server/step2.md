For OpenShift to understand the available NFS shares, it requires a _PersistentVolume_ configuration. The _PersistentVolume_ supports different protocols for storing data, such as AWS EBS volumes, GCE storage, OpenStack Cinder, Glusterfs and NFS. The configuration provides an abstraction between storage and API allowing for a consistent experience.

In the case of NFS, one _PersistentVolume_ relates to one NFS directory. When a container has finished with the volume, the data can either be _Retained_ for future use or the volume can be _Recycled_ meaning all the data is deleted. The policy is defined by the _ persistentVolumeReclaimPolicy_ option.

For structure is:
<pre>
apiVersion: v1
kind: PersistentVolume
metadata:
  name: &lt;openshift-friendly-name&gt;
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  nfs:
    server: &lt;server-name&gt;
    path: &lt;shared-path&gt;
</pre>

The spec defines additional metadata about the persistent volume, including how much space is available and if it has read/write access.

## Task

Create two new PersistentVolume definitions to point at the two available NFS shares.

`oc create -f nfs-0001.yaml`{{execute}}

`oc create -f nfs-0002.yaml`{{execute}}

View the contents of the files using `cat nfs-0001.yaml nfs-0002.yaml`{{execute}}

Once created, view all _PersistentVolumes_ in the cluster using `oc get pv`{{execute}}
