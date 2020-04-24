RWX storage is a special kind of storage that can be mounted on several pods at the same time.

With OCS, each RWX storage device is backed by the battle-tested and high-performance distributed filesystem known as CephFS.

This storage type is well suited for scalable applications that need a shared filesystem storage. An example of this are webservers that are dynamically scaled up and down based on the amount of visitors.

In this section the `ocs-storagecluster-cephfs` *Storage Class* will be used to create a RWX (ReadWriteMany) PVC that can be used by multiple pods at the same time. The application we will use is called `File Uploader`.

Create a new project:

`oc new-project my-shared-storage`{{execute}}

Next deploy the example PHP application called `file-uploader`:

`oc new-app openshift/php:7.1~https://github.com/christianh814/openshift-php-upload-demo --name=file-uploader`{{execute}}

#### Sample Output:
<pre>
--> Found image 665111f (6 days old) in image stream "openshift/php" under tag "7.1" for "openshift/php:7.1"

    Apache 2.4 with PHP 7.1
    -----------------------
    PHP 7.1 available as container is a base platform for building and running various PHP 7.1 applications and frameworks. PHP is an HTML-embedded scripting language. PHP attempts to make it easy for developers to write dynamically generated web pages. PHP also offers built-in database integration for several commercial and non-commercial database management systems, so writing a database-enabled webpage with PHP is fairly simple. The most common use of PHP coding is probably as a replacement for CGI scripts.

    Tags: builder, php, php71, rh-php71

    * A source build using source code from https://github.com/christianh814/openshift-php-upload-demo will be created
      * The resulting image will be pushed to image stream tag "file-uploader:latest"
      * Use 'oc start-build' to trigger a new build
    * This image will be deployed in deployment config "file-uploader"
    * Ports 8080/tcp, 8443/tcp will be load balanced by service "file-uploader"
      * Other containers can access this service through the hostname "file-uploader"

--> Creating resources ...
    imagestream.image.openshift.io "file-uploader" created
    buildconfig.build.openshift.io "file-uploader" created
    deploymentconfig.apps.openshift.io "file-uploader" created
    service "file-uploader" created
--> Success
    Build scheduled, use 'oc logs -f bc/file-uploader' to track its progress.
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose svc/file-uploader'
    Run 'oc status' to view your app.
</pre>

Watch and wait for the application to be deployed:

`oc logs -f bc/file-uploader -n my-shared-storage`{{execute}}

#### Sample Output:

<pre>
Cloning "https://github.com/christianh814/openshift-php-upload-demo" ...

[...]

Generating dockerfile with builder image image-registry.openshift-image-registry.svc:5000/openshift/php@sha256:a06311381a15078be4d67cf844ba808e688dfe25305c6a696a19aee9b93c72d5
STEP 1: FROM image-registry.openshift-image-registry.svc:5000/openshift/php@sha256:a06311381a15078be4d67cf844ba808e688dfe25305c6a696a19aee9b93c72d5
STEP 2: LABEL "io.openshift.build.source-location"="https://github.com/christianh814/openshift-php-upload-demo" "io.openshift.build.image"="image-registry.openshift-image-registry.svc:5000/openshift/php@sha256:a06311381a15078be4d67cf844ba808e688dfe25305c6a696a19aee9b93c72d5" "io.openshift.build.commit.author"="Christian Hernandez <christian.hernandez@yahoo.com>" "io.openshift.build.commit.date"="Sun Oct 1 17:15:09 2017 -0700" "io.openshift.build.commit.id"="288eda3dff43b02f7f7b6b6b6f93396ffdf34cb2" "io.openshift.build.commit.ref"="master" "io.openshift.build.commit.message"="trying to modularize"
STEP 3: ENV OPENSHIFT_BUILD_NAME="file-uploader-1" OPENSHIFT_BUILD_NAMESPACE="my-shared-storage" OPENSHIFT_BUILD_SOURCE="https://github.com/christianh814/openshift-php-upload-demo" OPENSHIFT_BUILD_COMMIT="288eda3dff43b02f7f7b6b6b6f93396ffdf34cb2"
STEP 4: USER root
STEP 5: COPY upload/src /tmp/src
STEP 6: RUN chown -R 1001:0 /tmp/src
time="2019-11-20T18:53:16Z" level=warning msg="pkg/chroot: error unmounting \"/tmp/buildah873160532/mnt/rootfs\": error checking if \"/tmp/buildah873160532/mnt/rootfs/sys/fs/cgroup/memory\" is mounted: no such file or directory"
time="2019-11-20T18:53:16Z" level=warning msg="pkg/bind: error unmounting \"/tmp/buildah873160532/mnt/rootfs\": error checking if \"/tmp/buildah873160532/mnt/rootfs/sys/fs/cgroup/memory\" is mounted: no such file or directory"
STEP 7: USER 1001
STEP 8: RUN /usr/libexec/s2i/assemble
---> Installing application source...
=> sourcing 20-copy-config.sh ...
---> 18:53:16     Processing additional arbitrary httpd configuration provided by s2i ...
=> sourcing 00-documentroot.conf ...
=> sourcing 50-mpm-tuning.conf ...
=> sourcing 40-ssl-certs.sh ...
time="2019-11-20T18:53:17Z" level=warning msg="pkg/chroot: error unmounting \"/tmp/buildah357283409/mnt/rootfs\": error checking if \"/tmp/buildah357283409/mnt/rootfs/sys/fs/cgroup/memory\" is mounted: no such file or directory"
time="2019-11-20T18:53:17Z" level=warning msg="pkg/bind: error unmounting \"/tmp/buildah357283409/mnt/rootfs\": error checking if \"/tmp/buildah357283409/mnt/rootfs/sys/fs/cgroup/memory\" is mounted: no such file or directory"
STEP 9: CMD /usr/libexec/s2i/run
STEP 10: COMMIT temp.builder.openshift.io/my-shared-storage/file-uploader-1:562d8fb3
Getting image source signatures

[...]

Writing manifest to image destination
Storing signatures
Successfully pushed image-registry.openshift-image-registry.svc:5000/my-shared-storage/file-uploader@sha256:74029bb63e4b7cb33602eb037d45d3d27245ffbfc105fd2a4587037c6b063183
Push successful
</pre>

The command prompt returns out of the tail mode once you see _Push successful_.

---
**NOTE**

This use of the `new-app` command directly asked for application code to be
built and did not involve a template. That's why it only created a *single
Pod* deployment with a *Service* and no *Route*.
---

Let's make our application production ready by exposing it via a `Route` and scale to 3 instances for high availability:

`oc expose svc/file-uploader -n my-shared-storage`{{execute}}

`oc scale --replicas=3 dc/file-uploader -n my-shared-storage`{{execute}}

`oc get pods -n my-shared-storage`{{execute}}

You should have 3 `file-uploader` *Pods* in a few minutes. The additional `Route` allows us to access the application from outside of the Openshift cluster.

---
**CAUTION**

Never attempt to store persistent data in a *Pod* that has no persistent
volume associated with it. *Pods* and their containers are ephemeral by
definition, and any stored data will be lost as soon as the *Pod* terminates
for whatever reason.
---

The app is of course not useful like this. We can fix this by providing shared
storage to this app.

You can create a *PersistentVolumeClaim* and attach it into an application with
the `oc set volume` command. Execute the following

```
oc set volume dc/file-uploader --add --name=my-shared-storage \
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
