If any CockroachDB member fails it gets restarted or recreated automatically by the Kubernetes infrastructure, and will rejoin the cluster automatically when it comes back up. You can test this scenario by killing any of the pods:

```
oc delete pods -l app.kubernetes.io/component=cockroachdb
```{{execute}}
<br>
Watch the pods respawn:

```
oc get pods -l app.kubernetes.io/component=cockroachdb
```{{execute}}
<br>
Confirm that the contents of the database still persist by connecting to the database cluster:

```
COCKROACHDB_PUBLIC_SERVICE=`oc get svc -o jsonpath={$.items[1].metadata.name}`
oc run -it --rm cockroach-client --image=cockroachdb/cockroach --restart=Never --command -- ./cockroach sql --insecure --host $COCKROACHDB_PUBLIC_SERVICE
```{{execute}}
<br>
Once you see the SQL prompt, run the following to confirm the database contents are still present:

```
SELECT * FROM bank.accounts;
```{{execute}}
<br>
Exit the SQL prompt:
```
\q
```{{execute}}
