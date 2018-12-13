
To access the Operator Lifecycle Manager via the UI, we will run a local copy of the UI found in the container image `quay.io/openshift/origin-console:latest`.

The local console proxy utilizes the `system:serviceaccount:kube-system:default` Service Account to access all resources.

We will first grant this Service Account `cluster-admin` access. **DO NOT DO THIS IN PRODUCTION**.

```
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:kube-system:default
```{{execute}}
<br>
Serve up the Operator-centric Origin console locally.

```
./operator-lifecycle-manager/scripts/run_console_local.sh
```{{execute}}
<br>
To access the UI, select the **+** button in the terminal, select `Select port to view on Host 1`, and enter port `9000`.