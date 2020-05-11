Verify that you can access the CockroachDB Web UI by first exposing the CockroachDB Service as a publicly accessible OpenShift Route:

```
COCKROACHDB_PUBLIC_SERVICE=`oc get svc -o jsonpath={$.items[1].metadata.name}`
oc expose --port=http svc $COCKROACHDB_PUBLIC_SERVICE
```{{execute}}
<br>
Fetch the OpenShift Route URL and copy/paste it into your browser:

```
COCKROACHDB_UI_URL=`oc get route -o jsonpath={$.items[0].spec.host}`
echo $COCKROACHDB_UI_URL
```{{execute}}