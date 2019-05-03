***

_This step doesn't require changes to the interactive environment, but feel free to explore._

***

To pass 'extra vars' to the Playbooks/Roles being run by the Operator, you can embed key-value pairs in the 'spec' section of the *Custom Resource (CR)*.

This is equivalent to how [*--extra-vars*](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#passing-variables-on-the-command-line) can be passed into the  _ansible-playbook_ command.

## Example CR with extra-vars

The CR snippet below shows two 'extra vars' (`message` and `newParamater`) being passed in via `spec`. Passing 'extra vars' through the CR allows for customization of Ansible logic based on the contents of each CR instance.
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


## Accessing CR Fields

Now that you've passed 'extra vars' to your Playbook through the CR `spec`, we need to read them from the Ansible logic that makes up your Operator.

Variables passed in through the CR spec are made available at the top-level to be read from Jinja templates. For the CR example above, we could read the vars 'message' and 'newParameter' from a Playbook like so:

```
- debug:
    msg: "message value from CR spec: {{ message }}"

- debug:
    msg: "newParameter value from CR spec: {{ new_parameter }}"  

```

Did you notice anything strange about the snippet above? The 'newParameter' variable that we set on our CR spec was accessed as 'new_parameter'. Keep this automatic conversion from camelCase to snake_case in mind, as it will happen to all 'extra vars' passed into the CR spec.

Refer to the next section for further info on reaching into the JSON structure exposed in the Ansible Operator runtime environment.

### JSON Structure 

When a reconciliation job runs, the content of the associated CR is made available as variables in the Ansible runtime environment.

The JSON below is an example of what gets passed into ansible-runner (the Ansible Operator runtime). 

Note that vars added to the 'spec' section of the CR ('message' and 'new_parameter') are placed at the top-level of this structure for easy access. 

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

### Accessing CR metadata

The `meta` fields provide the CR 'name' and 'namespace' associated with a reconciliation job. These and other nested fields can be accessed with dot notation in Ansible.

```yaml
- debug:
    msg: "name: {{ meta.name }}, namespace: {{ meta.namespace }}"

```

In the next step, we'll use `operator-sdk` to generate our Operator project scaffolding.
