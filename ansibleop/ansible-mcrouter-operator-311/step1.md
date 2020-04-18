Let's begin my creating a new project called `mcrouter`:

```
oc new-project mcrouter
```{{execute}}
<br>
Let's use one command to deploy the Mcrouter CRD, Service Account, Role, RoleBinding, and Operator Deployment into the cluster:

```
oc apply -f https://raw.githubusercontent.com/geerlingguy/mcrouter-operator/master/deploy/mcrouter-operator.yaml
```{{execute}}
<br>
Let's now verify that all the objects were successfully deployed. Begin by verifying the `kind: Mcrouter` CRD:

```
oc get crd
```{{execute}}
<br>
Verify the `mcrouter-operator` Service Account. This Service Account is responsible for the identity of the Mcrouter Operator Deployment.

```
oc get sa
```{{execute}}
<br>
Verify the `mcrouter-operator` Role. This Role defines the Role-Based Access Control for the `mcrouter-operator` Service Account.

```
oc get role
```{{execute}}
<br>
Verify the `mcrouter-operator` RoleBinding. This RoleBinding applies our Role to the `mcrouter-operator` Service Account.

```
oc get rolebinding
```{{execute}}
<br>
Finally, we will verify that the Mcrouter Deployment and its associated pod are successfully running:

```
oc get deploy,pod
```{{execute}}
<br>
This Deployment consists of two containers: `operator` and `ansible`. The `ansible` container exists only to expose the standard Ansible stdout logs. The `operator` container contains our Ansible Operator Mcrouter roles/playbooks. Observe the log files for both containers:

```
oc logs deploy/mcrouter-operator -c operator
```{{execute}}
<br>
Observe the log files for the Ansible container (it should currently be empty because we have yet to create a Custom Resource).

```
oc logs deploy/mcrouter-operator -c ansible
```{{execute}}
<br>
Observe the Service exposing the Operator's [Prometheus metrics endpoint](https://prometheus.io/docs/guides/go-application/#how-go-exposition-works). Ansible-Operator automatically registers this endpoint for you.

```
oc get svc -l name=mcrouter-operator
```{{execute}}