The Custom Resource file format is a Kubernetes resource file. The object has mandatory fields:

* **apiVersion**: The version of the Custom Resource that will be created.

* **kind**: The kind of the Custom Resource that will be created

* **metadata**: Kubernetes specific metadata to be created

* **spec**: This is the key-value list of variables which are passed to Ansible. This field is optional and will be empty by default.

* **annotations**: Kubernetes specific annotations to be appended to the CR. See the below section for Ansible Operator specific annotations.

**Ansible Operator annotations**

This is the list of CR annotations which will modify the behavior of the operator:

* **ansible.operator-sdk/reconcile-period**: Used to specify the reconciliation interval for the CR. This value is parsed using the standard Golang package time. Specifically ParseDuration is used which will use the default of s suffix giving the value in seconds.

Example:

```yaml
apiVersion: "foo.example.com/v1alpha1"
kind: "Foo"
metadata:
  name: "example"
annotations:
  ansible.operator-sdk/reconcile-period: "30s"
```
