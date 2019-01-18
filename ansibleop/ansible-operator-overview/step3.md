***

_This step doesn't require changes to the interactive environment, but feel free to explore._

***

Using Ansible Operator, a *change in the state* of a Custom Resource (CR) signals to the Operator that certain Playbooks/Roles should be executed. So what does a Custom Resource look like?

As a creator/user of an Ansible Operator, you'll create CRs to test that your Operator has the expected response to each CR trigger.

## Structure of a Custom Resource 

The Custom Resource takes the format of a Kubernetes resource. The object definition has _mandatory_ fields:

### Mandatory Fields

* **apiVersion**: Version of the Custom Resource that will be created

* **kind**: Kind of the Custom Resource that will be created

* **metadata**: Kubernetes metadata that will be created

* **spec**: Key-value list of variables which are passed to Ansible. *Optional* and will be empty by default.

* **annotations**: Kubernetes annotations to be appended to the CR. See the below section for Ansible Operator specific annotations.

### Annotations
Custom Resource annotations can be applied to modify Ansible Operator behavior:

* **ansible.operator-sdk/reconcile-period**: Used to specify the reconciliation interval for the CR. 
  * This value is parsed using the standard [Golang 'Package time'](https://golang.org/pkg/time/). Specifically, ParseDuration is used which will use the default of an 's' suffix giving the value in seconds (e.g. "30" would become "30s" as shown below).

## Custom Resource Example
If an Ansible Operator was watching for events from `kind: Foo` with `apiVersion: foo.example.com/v1alpha1`, an Ansible Playbook/Role could be triggered in response to creation of the resource shown below.

```yaml
apiVersion: "foo.example.com/v1alpha1"
kind: "Foo"
metadata:
  name: "example"
annotations:
  ansible.operator-sdk/reconcile-period: "30s"
```
