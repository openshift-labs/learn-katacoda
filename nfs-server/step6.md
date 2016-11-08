Because a remote NFS server stores the data, if the Pod or the Host were to go down, then the data will still be available.

## Task

Deleting a Pod will cause it to remove claims to any persistent volumes. New Pods can pick up and re-use the NFS share.

`oc delete pod www`{{execute}}

`oc create -f pod-www.yaml`{{execute}}

`ip=$(oc get pod www -o yaml |grep podIP | awk '{split($0,a,":"); print a[2]}'); curl $ip`{{execute}}

The applications now use a remote NFS for their data storage. Depending on requirements, this same approach works with other storage engines such as GlusterHQ, AWS EBS, GCE storage or OpenStack Cinder.
