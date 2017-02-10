To make changes to an existing resource object you can use the ``oc edit`` command.

To edit the details of the ``route`` object for the sample application you can run ``oc edit route/coming-soon``{{execute}}

This will start up an editor from which you can edit the definition of the resource object. By default the definition will be provided as YAML. To edit the definition as JSON add the ``-o json`` option.

Once you are done with any edits, save the changes and quit the editor. The changes will be automatically uploaded and used to replace the original definition.

As OpenShift works on a declarative configuration model, the platform will then run any steps needed to bring the state of the cluster into agreement with the required state as defined by the resource object.

Do be aware that not all fields of a resource object are able to be changed. Some fields may be immutable. Others may represent the current state of the corresponding resource and any change will be overridden again with the current state.
