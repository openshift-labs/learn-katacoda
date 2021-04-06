RWX storage is a special kind of storage that can be mounted on several pods at the same time.

With ODF, each RWX storage device is backed by the battle-tested and high-performance distributed filesystem known as CephFS.

This storage type is well suited for scalable applications that need a shared filesystem storage. An example of this are webservers that are dynamically scaled up and down based on the amount of visitors.

In this section the `ocs-storagecluster-cephfs` _Storage Class_ will be used to create a RWX (ReadWriteMany) PVC that can be used by multiple pods at the same time. The application we will use is called `File Uploader`.

Create a new project:

`oc new-project my-shared-storage`{{execute}}

Next deploy the example PHP application called `file-uploader`:

`oc new-app openshift/php:7.2-ubi8~https://github.com/christianh814/openshift-php-upload-demo --name=file-uploader`{{execute}}

#### Sample Output:

<pre>
--> Found image 343298a (4 months old) in image stream "openshift/php" under tag "7.2-ubi8" for "openshift/php:7.2-ubi8"

    Apache 2.4 with PHP 7.2
    -----------------------
    PHP 7.2 available as container is a base platform for building and running various PHP 7.2 applications and frameworks. PHP is an HTML-embedded scripting language. PHP attempts to make it easy for developers to write dynamically generated web pages. PHP also offers built-in database integration for several commercial and non-commercial database management systems, so writing a database-enabled webpage with PHP is fairly simple. The most common use of PHP coding is probably as a replacement for CGI scripts.

    Tags: builder, php, php72, php-72

    * A source build using source code from https://github.com/christianh814/openshift-php-upload-demo will be created
      * The resulting image will be pushed to image stream tag "file-uploader:latest"
      * Use 'oc start-build' to trigger a new build

--> Creating resources ...
    imagestream.image.openshift.io "file-uploader" created
    buildconfig.build.openshift.io "file-uploader" created
    deployment.apps "file-uploader" created
    service "file-uploader" created
--> Success
    Build scheduled, use 'oc logs -f buildconfig/file-uploader' to track its progress.
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/file-uploader'
    Run 'oc status' to view your app.
</pre>

Watch and wait for the application to be deployed:

`oc logs -f bc/file-uploader -n my-shared-storage`{{execute}}

#### Sample Output:

<pre>
Cloning "https://github.com/christianh814/openshift-php-upload-demo" ...

[...]

Pushing image image-registry.openshift-image-registry.svc:5000/my-shared-storage/file-uploader:latest ...
Getting image source signatures
Copying blob sha256:38d76788a718aa4aeefa83bd12ccf249932c24713cb71a7172cb2bae0ff7e48c
Copying blob sha256:ec1681b6a383e4ecedbeddd5abc596f3de835aed6db39a735f62395c8edbff30
Copying blob sha256:35ad9b4fba1fa6b00a6f266303348dc0cf9a7c341616e800c2738030c0f64167
Copying blob sha256:c4d668e229cd131e0a8e4f8218dca628d9cf9697572875e355fe4b247b6aa9f0
Copying blob sha256:da1cc572023a942fff15d59aefa5abbb59d2c24a03966db8074ef8f9bab277d4
Copying blob sha256:121960b91b0d2c80b28494b15c026c2cc69f47f50b043b2b9f27b863d5b6d397
Copying config sha256:9c9e63275e81b86d3d3571740b06b805f7b0be47c5e2e1ac60197474af4361b2
Writing manifest to image destination
Storing signatures
Successfully pushed image-registry.openshift-image-registry.svc:5000/my-shared-storage/file-uploader@sha256:1deccaded779afd9d761fffe93ae9a47d6fa29bc20b52eed37f5dd0766913fae
Push successful
</pre>

The command prompt returns out of the tail mode once you see _Push successful_.

---

**NOTE**

This use of the `new-app` command directly asked for application code to be
built and did not involve a template. That's why it only created a _single
Pod_ deployment with a _Service_ and no _Route_.

---

Let's make our application production ready by exposing it via a `Route` and scale to 3 instances for high availability:

`oc expose svc/file-uploader -n my-shared-storage`{{execute}}

`oc scale --replicas=3 deploy/file-uploader -n my-shared-storage`{{execute}}

`oc get pods -n my-shared-storage`{{execute}}

You should have 3 `file-uploader` _Pods_ in a few minutes. The additional `Route` allows us to access the application from outside of the Openshift cluster.

---

**CAUTION**

Never attempt to store persistent data in a _Pod_ that has no persistent
volume associated with it. _Pods_ and their containers are ephemeral by
definition, and any stored data will be lost as soon as the _Pod_ terminates
for whatever reason.

---

The app is of course not useful like this. We can fix this by providing shared
storage to this app.

You can create a _PersistentVolumeClaim_ and attach it into an application with
the `oc set volume` command. Execute the following

````
oc set volume deploy/file-uploader --add --name=my-shared-storage \
-t pvc --claim-mode=ReadWriteMany --claim-size=1Gi \
--claim-name=my-shared-storage --claim-class=ocs-storagecluster-cephfs \
--mount-path=/opt/app-root/src/uploaded \
-n my-shared-storage
```{{execute}}

This command will:

* create a *PersistentVolumeClaim*
* update the *DeploymentConfig* to include a `volume` definition
* update the *DeploymentConfig* to attach a `volumemount` into the specified `mount-path`
* cause a new deployment of the 3 application *Pods*

For more information on what `oc set volume` is capable of, look at its help output
with `oc set volume -h`. Now, let's look at the result of adding the volume:

`oc get pvc -n my-shared-storage`{{execute}}

#### Sample Output:

<pre>
NAME                STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS                AGE
my-shared-storage   Bound    pvc-371c2184-fb73-11e9-b901-0aad1a53052d   1Gi        RWX            ocs-storagecluster-cephfs   47s
</pre>

Notice the `ACCESSMODE` being set to *RWX* (short for `ReadWriteMany`).

All 3 `file-uploader`*Pods* are using the same *RWX* volume. Without this `ACCESSMODE`, OpenShift will not attempt to attach multiple *Pods* to the same *PersistentVolume*
reliably. If you attempt to scale up deployments that are using *RWO* or `ReadWriteOnce` storage, the *Pods* will actually all become co-located on the same
node.

If you want to clean your screen before continuing, just execute:
`clear`{{execute}}
````
