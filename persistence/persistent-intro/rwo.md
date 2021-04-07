RWO storage is the most basic type of storage that is supported by most dynamic storage provisioners in the Kuberneted eco system.

With Openshift Container Storage (ODF), each RWO storage device is backed by its own block device, which means that it is well suited for high-IOPs and low-latency operations that are common for database workloads.

In this section the `ocs-storagecluster-ceph-rbd` _storage class_ will be used by an Openshift application + database _deployment_ to create RWO (ReadWriteOnce) persistent storage. The persistent storage will be a Ceph RBD (RADOS Block Device) volume (object) in the Ceph pool `ocs-storagecluster-cephblockpool`.

To do so we have created a template file, based on the OpenShift rails-pgsql-persistent template, that includes an extra parameter STORAGE_CLASS that enables the end user to specify the storage class the PVC (Persistent Volume Claim) should use.

````
oc new-project my-database-app
oc new-app rwo_rails_app.yaml -p STORAGE_CLASS=ocs-storagecluster-ceph-rbd -p VOLUME_CAPACITY=5Gi
```{{execute}}

After the deployment is started you can monitor with these commands.

`oc status`{{execute}}

Check the PVC that were created.

`oc get pvc -n my-database-app`{{execute}}

This step could take a few minutes. Wait until there are 2 *Pods* in `Running` STATUS and 4 *Pods* in `Completed` STATUS as shown below.

`watch oc get pods -n my-database-app`{{execute}}

---

**Example output:**

<pre>
NAME                                READY   STATUS      RESTARTS   AGE
postgresql-1-deploy                 0/1     Completed   0          5m48s
postgresql-1-lf7qt                  1/1     Running     0          5m40s
rails-pgsql-persistent-1-build      0/1     Completed   0          5m49s
rails-pgsql-persistent-1-deploy     0/1     Completed   0          3m36s
rails-pgsql-persistent-1-hook-pre   0/1     Completed   0          3m28s
rails-pgsql-persistent-1-pjh6q      1/1     Running     0          3m14s
</pre>

---

You can exit by pressing <kbd>Ctrl</kbd>+<kbd>C</kbd>

Once the deployment is complete you can now test the application and the persistent storage on Ceph:

*URL*  http://rails-pgsql-persistent-my-database-app.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/articles/

The articles and comments are saved in a PostgreSQL database which stores its table spaces on the Ceph RBD volume provisioned using the `ocs-storagecluster-ceph-rbd` *storageclass* during the application deployment.

To log in, use the following credentials:

<pre>
username: openshift
password: secret
</pre>

If you want to clean your screen before continuing, just execute:
`clear`{{execute}}
````
