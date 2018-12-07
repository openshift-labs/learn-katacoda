Use the CLI to create a new Ansible-based Operator project with the new command.
 `operator-sdk new --type ansible` has two required flags `--api-version` and
 `--kind`. These flags are used to generate proper Custom Resource files and an
 Ansible Role whose name matches the input for `--kind`. An example of this
 command is:

`operator-sdk new memcached-operator --api-version=cache.example.com/v1alpha1 --kind=Memcached --type=ansible --skip-git-init`{{execute}}

`cd memcached-operator`{{execute}}

This creates a new memcached-operator project specifically for watching the
Memcached resource with APIVersion `cache.example.com/v1apha1` and Kind
`Memcached`.

### Project Scaffolding Layout

After creating a new operator project using `operator-sdk new --type ansible`,
the project directory has numerous generated folders and files. The following
table describes a basic rundown of each generated file/directory.

| File/Folders   | Purpose                           |
| :---           | :--- |
| deploy | Contains a generic set of kubernetes manifests for deploying this operator on a kubernetes cluster. |
| roles | Contains an Ansible Role initialized using [Ansible Galaxy](https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html)
| build | Contains scripts that the operator-sdk uses for build and initialization. |
| watches.yaml | Contains Group, Version, Kind, and Ansible invocation method. |
