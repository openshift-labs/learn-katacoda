Next, we'll learn how to use the operator-sdk CLI to create an Ansible Operator project with the 'new' command.

A basic (but incomplete) 'new' command looks like this:
```bash
operator-sdk new <project-name> --type ansible
``` 
This command tells operator-sdk to initialize a new Ansible Operator project scaffolding with a name of your choosing. 

_However_, we need to add a few more required arguments via flags before running the command. 
 - `--api-version`
   - Kubernetes apiVersion, has a format of $GROUP_NAME/$VERSION (e.g myapp.example.com/v1alpha1)
 - `--kind` 
   - Kubernetes Custom Resource kind (e.g MyOperatedApp)

These flags are used by operator-sdk to generate:
 - Custom Resource files customized according to flag arguments
 - An Ansible Role whose name matches the input for '--kind'. 

Putting it all together, we end up with a command that looks like this:
```bash
$ operator-sdk new my-project --type=ansible --api-version=myapi.example.com/v1alpha1 --kind=MyOperatedApp
[...]

# See if you can spot similarities between command args and generated scaffolding.

$ tree my-project/

my-project/
├── build
│   └── Dockerfile
├── deploy
│   ├── crds
│   │   ├── myapi_v1alpha1_myoperatedapp_crd.yaml
│   │   └── myapi_v1alpha1_myoperatedapp_cr.yaml
│   ├── operator.yaml
│   ├── role_binding.yaml
│   ├── role.yaml
│   └── service_account.yaml
├── roles
│   └── MyOperatedApp
│       ├── defaults
│       │   └── main.yml
│       ├── files
│       ├── handlers
│       │   └── main.yml
│       ├── meta
│       │   └── main.yml
│       ├── README.md
│       ├── tasks
│       │   └── main.yml
│       ├── templates
│       ├── tests
│       │   ├── inventory
│       │   └── test.yml
│       └── vars
│           └── main.yml
└── watches.yaml

```

# Running 'operator-sdk new'
***
__Now it's your turn!__ We'll be building a [__Memcached__](https://memcached.org/) Ansible Operator for the remainder of this scenario. 
***

Go ahead and run the command below to generate the Ansible Operator project scaffolding.

`operator-sdk new memcached-operator --type=ansible --api-version=cache.example.com/v1alpha1 --kind=Memcached --skip-git-init`{{execute}}

This creates a new memcached-operator project specifically for watching the
Memcached resource with APIVersion 'cache.example.com/v1apha1' and Kind
'Memcached'.

## Inspecting 'operator-sdk new' results

Inspect the memcached-operator directory structure for yourself with 'tree', and then 'cd' into it.

`tree memcached-operator`{{execute}}

`cd memcached-operator`{{execute}}



### Project Scaffolding Layout

After creating a new operator project using `operator-sdk new --type ansible`,
the project directory has numerous generated folders and files. The following
table describes a basic rundown of each generated file/directory.

| File/Folders   | Purpose                           |
| :---           | :--- |
| deploy | Contains a generic set of Kubernetes manifests for deploying this operator on a Kubernetes cluster. |
| roles | Contains an Ansible Role initialized using [Ansible Galaxy](https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html)
| build | Contains scripts that the operator-sdk uses for build and initialization. |
| watches.yaml | Contains Group, Version, Kind, and Ansible invocation method. |
