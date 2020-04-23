Get a list of all pods in the `myproject` Namespace:

```
oc get pods -n myproject
```{{execute}}
<br>
Create a ReplicaSet object manifest file:

```
cat > replica-set.yaml <<EOF
apiVersion: extensions/v1beta1
kind: ReplicaSet
metadata:
  name: myfirstreplicaset
  namespace: myproject
spec:
  selector:
    matchLabels:
     app: myfirstapp
  replicas: 3
  template:
    metadata:
      labels:
        app: myfirstapp
    spec:
      containers:
        - name: nodejs
          image: openshiftkatacoda/blog-django-py
EOF
```{{execute}}
<br>
Create the ReplicaSet:

```
oc apply -f replica-set.yaml
```{{execute}}
<br>
In a new terminal window, select all pods that match `app=myfirstapp`:

```
oc get pods -l app=myfirstapp --show-labels -w
```{{execute}}
<br>
Delete the pods and watch new ones spawn:

```
oc delete pod -l app=myfirstapp
```{{execute}}
<br>
Imperatively scale the ReplicaSet to 6 replicas:

```
oc scale replicaset myfirstreplicaset --replicas=6
```{{execute}}
<br>
Imperatively scale down the ReplicaSet to 3 replicas:

```
oc scale replicaset myfirstreplicaset --replicas=3
```{{execute}}
<br>
The `oc scale` command interacts with the `/scale` endpoint:

```
curl -X GET http://localhost:8001/apis/extensions/v1beta1/namespaces/myproject/replicasets/myfirstreplicaset/scale
```{{execute}}
<br>
Use the `PUT` method against the `/scale` endpoint to change the number of replicas to 5:

```
curl  -X PUT localhost:8001/apis/extensions/v1beta1/namespaces/myproject/replicasets/myfirstreplicaset/scale -H "Content-type: application/json" -d '{"kind":"Scale","apiVersion":"extensions/v1beta1","metadata":{"name":"myfirstreplicaset","namespace":"myproject"},"spec":{"replicas":5}}'
```{{execute}}
<br>
You can also get information regarding the pod by using the `GET` method against the `/status` endpoint

```
curl -X GET http://localhost:8001/apis/extensions/v1beta1/namespaces/myproject/replicasets/myfirstreplicaset/status
```{{execute}}
<br>
The status endpoint's primary purpose is to allow a controller (with proper RBAC permissions) to send a `PUT` method along with the desired status.
