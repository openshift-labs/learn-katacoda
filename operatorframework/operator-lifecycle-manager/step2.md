
To access the Operator Lifecycle Manager via the UI, we will run a local copy of the UI found in the container image `quay.io/openshift/origin-console:latest`.

The local console proxy utilizes the `system:serviceaccount:kube-system:default` Service Account to access all resources.

We will first grant this Service Account `cluster-admin` access. **DO NOT DO THIS IN PRODUCTION**.

```
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:kube-system:default
```{{execute}}
<br>
Replace the Operator-centric Origin console container image `latest` tag with `v3.11.0`.

```
sed -i 's|latest|v3.11.0|g' ./operator-lifecycle-manager/scripts/run_console_local.sh
```{{execute}}
<br>
Serve up the Operator-centric Origin console locally.

```
./operator-lifecycle-manager/scripts/run_console_local.sh
```{{execute}}
<br>
To access the UI, visit https://[[HOST_SUBDOMAIN]]-9000-[[KATACODA_HOST]].environments.katacoda.com
