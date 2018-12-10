The extravars that are sent to Ansible are predefined and managed by the
operator. The `spec` section will pass along the key-value pairs as extra vars.
This is equivalent to how above extra vars are passed in to `ansible-playbook`.

For the CR example:

```yaml
apiVersion: "app.example.com/v1alpha1"
kind: "Database"
metadata:
  name: "example"
spec:
  message: "Hello world 2"
  newParameter: "newParam"
```

The structure is:

```json
{ "meta": {
        "name": "<cr-name>",
        "namespace": "<cr-namespace>",
  },
  "message": "Hello world 2",
  "new_parameter": "newParam",
  "_app_example_com_database": {
     <Full CR>
   },
}
```

*Note:* The resulting JSON structure that is passed in as extra vars are
autoconverted to snake-case. newParameter becomes `new_parameter`.

`message` and `newParameter` are set in the top level as extra variables and
`meta` provides the relevant metadata for the Custom Resource as defined in the
operator. The `meta` fields can be access via dot notation in Ansible as so:

```yaml
---
- debug:
    msg: "name: {{ meta.name }}, {{ meta.namespace }}"
```
