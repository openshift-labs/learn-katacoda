An Object Bucket Claim (OBC) can be used to request a S3 compatible bucket backend for your workloads. When creating an OBC you get a ConfigMap (CM) and a Secret that together contain all the information your application needs to use the object storage service.

NooBaa is an upstream technology within ODF that allows you to provide multi-cloud object access. For this exercise, we'll be using the NooBaa command to do S3 API calls for your application.

Creating an OBC is as simple as using the NooBaa CLI:

`noobaa obc create test21obc -n openshift-storage`{{execute}}

---

**Example output:**

INFO[0001] ✅ Created: ObjectBucketClaim "test21obc"

---

The NooBaa CLI has created the necessary configuration inside of NooBaa and has informed Openshift about the new OBC:

`oc get obc -n openshift-storage`{{execute}}

---

**Example output:**

<pre>
NAME        STORAGE-CLASS                 PHASE   AGE
test21obc   openshift-storage.noobaa.io   Bound   38s
</pre>

---

`oc get obc test21obc -o yaml -n openshift-storage`{{execute}}

---

**Example output:**

```yaml
apiVersion: objectbucket.io/v1alpha1
kind: ObjectBucketClaim
metadata:
  creationTimestamp: "2019-10-24T13:30:07Z"
  finalizers:
    - objectbucket.io/finalizer
  generation: 2
  labels:
    app: noobaa
    bucket-provisioner: openshift-storage.noobaa.io-obc
    noobaa-domain: openshift-storage.noobaa.io
  name: test21obc
  namespace: openshift-storage
  resourceVersion: "40756"
  selfLink: /apis/objectbucket.io/v1alpha1/namespaces/openshift-storage/objectbucketclaims/test21obc
  uid: 64f04cba-f662-11e9-bc3c-0295250841af
spec:
  ObjectBucketName: obc-openshift-storage-test21obc
  bucketName: test21obc-933348a6-e267-4f82-82f1-e59bf4fe3bb4
  generateBucketName: test21obc
  storageClassName: openshift-storage.noobaa.io
status:
  phase: Bound
```

---

Inside of your `openshift-storage` namespace, you will now find the _ConfigMap_ and the _Secret_ to use this OBC. The CM and the secret have the same name as the OBC:

`oc get -n openshift-storage secret test21obc -ojson | jq .data`{{execute}}

---

**Example output:**

```json
{
  "AWS_ACCESS_KEY_ID": "MkJZMVNVZ2t3eHIwTW14SWpvOFQ=",
  "AWS_SECRET_ACCESS_KEY": "WldwTk9yMUFHTFhpd1oyVTEzRnhza3BKS1A3dWdKSEx1a0tPZFJJdQ=="
}
```

---

`oc get -n openshift-storage configmap test21obc -ojson | jq .data`{{execute}}

---

**Example output:**

```json
{
  "BUCKET_HOST": "s3.openshift-storage.svc",
  "BUCKET_NAME": "test21obc-758f783c-1c59-4b5d-8ea1-824b1e97464a",
  "BUCKET_PORT": "443",
  "BUCKET_REGION": "",
  "BUCKET_SUBREGION": ""
}
```

---

As you can see, the secret gives us the S3 access credentials, while the ConfigMap contains the S3 endpoint information for our application.

### Using an OBC inside a container

In this section we will see how one can create an OBC using a YAML file and use the provided S3 configuration in an example application.

To deploy the OBC and the example application we apply this YAML file:

```yaml
apiVersion: objectbucket.io/v1alpha1
kind: ObjectBucketClaim
metadata:
  name: obc-test
spec:
  generateBucketName: "obc-test-noobaa"
  storageClassName: openshift-storage.noobaa.io
---
apiVersion: batch/v1
kind: Job
metadata:
  name: obc-test
  labels:
    app: obc-test
spec:
  template:
    metadata:
      labels:
        app: obc-test
    spec:
      restartPolicy: OnFailure
      containers:
        - image: mesosphere/aws-cli:latest
          command: ["sh"]
          args:
            - "-c"
            - "set -x && s3cmd --no-check-certificate --host $BUCKET_HOST:$BUCKET_PORT --host-bucket $BUCKET_HOST:$BUCKET_PORT du"
          name: obc-test
          env:
            - name: BUCKET_NAME
              valueFrom:
                configMapKeyRef:
                  name: obc-test
                  key: BUCKET_NAME
            - name: BUCKET_HOST
              valueFrom:
                configMapKeyRef:
                  name: obc-test
                  key: BUCKET_HOST
            - name: BUCKET_PORT
              valueFrom:
                configMapKeyRef:
                  name: obc-test
                  key: BUCKET_PORT
            - name: AWS_DEFAULT_REGION
              valueFrom:
                configMapKeyRef:
                  name: obc-test
                  key: BUCKET_REGION
            - name: AWS_ACCESS_KEY_ID
              valueFrom:
                secretKeyRef:
                  name: obc-test
                  key: AWS_ACCESS_KEY_ID
            - name: AWS_SECRET_ACCESS_KEY
              valueFrom:
                secretKeyRef:
                  name: obc-test
                  key: AWS_SECRET_ACCESS_KEY
```

The first part creates an OBC that will create a ConfigMap and a secret that have the same name as the OBC (`obc-test`). The second part of the file (after the `---`), creates a Job that deploys a container with the s3cmd pre-installed. It will execute s3cmd with the appropriate command line arguments and exit. S3cmd will in this case report the current disk usage of our S3 endpoint and exit, which will mark our _Pod_ as `Completed`.

Let's try this out:

#### Deploy the Manifest:

`oc apply -f obc_app_example.yaml`{{execute}}

---

**Example output:**

<pre>
namespace/obc-test created
objectbucketclaim.objectbucket.io/obc-test created
job.batch/obc-test created
</pre>

---

Afterwards watch the _Pod_ be Created, Run and finally be marked `Completed` like below - be aware that your Pod name will differ:

`oc get pods -n obc-test -l app=obc-test`{{execute}}

---

**Example output:**

<pre>
NAME             READY   STATUS      RESTARTS   AGE
obc-test-bvg8h   0/1     Completed   0          22s
</pre>

---

Then you can check the `obc-test` _Pod_ logs for the contents of the S3 bucket using the command below (in this case there are zero objects in the bucket).

NOTE: Fetching the obc-test log via the `oc` command does not work correctly. It does work using the `kubectl` command.

`kubectl logs -n obc-test -l app=obc-test`{{execute}}

---

**Example output:**

<pre>
+ s3cmd --no-check-certificate --host 10.0.140.19:30052 --host-bucket 10.0.140.19:30052 du
0        0 objects s3://obc-test-noobaa-784461cb-1e77-4ccf-b62d-007a6ae3ef15/
------
0        Total
</pre>

---

As we can see above, we can access one bucket, which is currently empty. This proves that the access credentials from the OBC work and are set up correctly inside of the container. +
Most applications support reading out the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables natively, but you will have to figure out how to set the host and bucket name for each application. In our example we used CLI flags of s3cmd for this.
