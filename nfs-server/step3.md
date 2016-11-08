Once a Persistent Volume is available, applications can claim the volume for their use. The claim is designed to stop applications accidentally writing to the same volume and causing conflicts and data corruption.

The claim specifies the requirements for a volume. This includes read/write access and storage space required. An example is as follows:

<pre>
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: claim-mysql
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
</pre>

## Task

Create two claims for two different applications. A MySQL Pod will use one claim, the other used by an HTTP server.

`oc create -f pvc-mysql.yaml`{{execute}}

`oc create -f pvc-http.yaml`{{execute}}

View the contents of the files using `cat pvc-mysql.yaml pvc-http.yaml`{{execute}}

Once created, view all _PersistentVolumesClaims_ in the cluster using `oc get pvc`{{execute}}.

The claim will output which Volume the claim is mapped to.
