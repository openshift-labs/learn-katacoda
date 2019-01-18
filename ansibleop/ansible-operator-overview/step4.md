***

_This step doesn't require changes to the interactive environment, but feel free to explore._

***

To pass 'extra vars' to the Playbooks/Roles being run by the Operator, you can embed key-value pairs in the 'spec' section of the *Custom Resource (CR)*.

This is equivalent to how [*--extra-vars*](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#passing-variables-on-the-command-line) can be passed into the  _ansible-playbook_ command.

## Example CR with extra-vars

The CR snippet below shows two 'extra vars' (_message, newParamater)_ being passed in via `spec` to be included in the Playbook/Role that the Operator will run.
```yaml
# Sample CR definition where some 
# 'extra vars' are passed via the spec
apiVersion: "app.example.com/v1alpha1"
kind: "Database"
metadata:
  name: "example"
spec:
  message: "Hello world 2"
  newParameter: "newParam"

```


### JSON Structure

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

*Note:* the resulting JSON structure that is passed in as extra vars is
auto-converted to _snake-case_. 

As an example, passing _newParameter_ as an 'extra var' will become _new_parameter_ in the JSON representation.

 - `message` and `newParameter` are set as 'extra vars'
 - `meta` provides the relevant metadata for the CR as defined in the
Operator. 

## Accessing CR Meta Fields
The `meta` fields can be accessed via dot notation in Ansible.

```
- debug:
    msg: "name: {{ meta.name }}, {{ meta.namespace }}"
```