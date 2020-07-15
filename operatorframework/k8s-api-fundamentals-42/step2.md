Verify the currently available Kubernetes API versions:

```
oc api-versions
```{{execute}}
<br>
Use the `--v` flag to set a verbosity level. This will allow you to see the request/responses against the Kubernetes API:

```
oc get pods --v=8
```{{execute}}
<br>
Use the `oc proxy` command to proxy local requests on port 8001 to the Kubernetes API:

```
oc proxy --port=8001
```{{execute T1}}
<br>
Open up another terminal by clicking the **+** button and select `Open New Terminal`.
<br>
<br>
Send a `GET` request to the Kubernetes API using `curl`:

```
curl -X GET http://localhost:8001
```{{execute T2}}
<br>
We can explore the OpenAPI definition file to see complete API details.

```
curl localhost:8001/openapi/v2
```{{execute}}
<br>
Send a `GET` request to list all pods in the environment:

```
curl -X GET http://localhost:8001/api/v1/pods
```{{execute}}
<br>
Use `jq` to parse the json response:

```
curl -X GET http://localhost:8001/api/v1/pods | jq .items[].metadata.name
```{{execute}}
<br>
We can scope the response by only viewing all pods in a particular namespace:

```
curl -X GET http://localhost:8001/api/v1/namespaces/myproject/pods
```{{execute}}
<br>
Get more details on a particular pod within the `myproject` namespace:

```
curl -X GET http://localhost:8001/api/v1/namespaces/myproject/pods/my-two-container-pod
```{{execute}}
<br>
Export the manifest associated with `my-two-container-pod` in json format:

```
oc get pods my-two-container-pod --export -o json > podmanifest.json
```{{execute}}
<br>
Within the manifest, replace the `1.13` version of alpine with `1.14`:

```
sed -i 's|nginx:1.13-alpine|nginx:1.14-alpine|g' podmanifest.json
```{{execute}}
<br>
Update/Replace the current pod manifest with the newly updated manifest:

```
curl -X PUT http://localhost:8001/api/v1/namespaces/myproject/pods/my-two-container-pod -H "Content-type: application/json" -d @podmanifest.json
```{{execute}}
<br>
Patch the current pod with a newer container image (`1.15`):

```
curl -X PATCH http://localhost:8001/api/v1/namespaces/myproject/pods/my-two-container-pod -H "Content-type: application/strategic-merge-patch+json" -d '{"spec":{"containers":[{"name": "server","image":"nginx:1.15-alpine"}]}}'
```{{execute}}
<br>
Delete the current pod by sending the `DELETE` request method:

```
curl -X DELETE http://localhost:8001/api/v1/namespaces/myproject/pods/my-two-container-pod
```{{execute}}
<br>
Verify the pod is in `Terminating` status:

```
oc get pods
```{{execute}}
<br>
Verify the pod no longer exists:

```
curl -X GET http://localhost:8001/api/v1/namespaces/myproject/pods/my-two-container-pod
```{{execute}}
