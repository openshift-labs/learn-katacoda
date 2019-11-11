Create a manifest for a Deployment with a Finalizer:

```
cat > finalizer-test.yaml<<EOF
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: finalizer-test
  namespace: myproject
  labels:
    app: finalizer-test
  finalizers:
    - finalizer.extensions/v1beta1  
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: finalizer-test
    spec:
      containers:
        - name: hieveryone
          image: openshiftkatacoda/blog-django-py
          imagePullPolicy: Always
          ports:
            - name: helloworldport
              containerPort: 8080
EOF
```{{execute}}
<br>
Create the Deployment.

```
oc create -f finalizer-test.yaml
```{{execute}}
<br>
Verify the Deployment has been created.

```
oc get deploy
```{{execute}}
<br>
Verify the ReplicaSet has been created:

```
oc get replicaset
```{{execute}}
<br>
Verify the pods are running:

```
oc get pods
```{{execute}}
<br>
Attempt to delete the Deployment.

```
oc delete deployment finalizer-test
```{{execute}}
<br>
Open up another terminal by clicking the **+** button and select `Open New Terminal`.
<br>
<br>
Observe the Deployment still exits and has been updated with the `deletionGracePeriodSeconds` and `deletionTimestamp` fields.

```
oc get deployment finalizer-test -o yaml | grep 'deletionGracePeriodSeconds\|deletionTimestamp'
```{{execute}}
<br>
Attempt to scale the Deployment up and down. Although status is updated, pods will not be created/deleted:

```
oc scale deploy finalizer-test --replicas=5
oc scale deploy finalizer-test --replicas=1
```{{execute}}
<br>

```
oc get deploy
oc get pods
```{{execute}}
<br>

Update the Deployment with the Finalizer value unset.

```
cat > finalizer-test-remove.yaml<<EOF
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: finalizer-test
  namespace: myproject
  labels:
    app: finalizer-test
  finalizers:
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: finalizer-test
    spec:
      containers:
        - name: hieveryone
          image: openshiftkatacoda/blog-django-py
          imagePullPolicy: Always
          ports:
            - name: helloworldport
              containerPort: 8080
EOF
```{{execute}}
<br>
Replace the Deployment.

```
oc replace -f finalizer-test-remove.yaml
```{{execute}}
<br>
The Deployment will now be deleted.

```
oc get deploy
oc get pods
```{{execute}}
<br>
See the following:

[Deployment Controller (DeletionTimestamp != nil)](https://github.com/kubernetes/kubernetes/blob/master/pkg/controller/deployment/deployment_controller.go#L610-L612)

[SyncStatusOnly Method](https://github.com/kubernetes/kubernetes/blob/master/pkg/controller/deployment/sync.go#L35-L44)