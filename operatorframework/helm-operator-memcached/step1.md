Let's begin my creating a new project called `myproject`:

```
oc new-project myproject
```{{execute}}

Memcached is an in-memory key-value store for small chunks of arbitrary data (strings, objects) from results of database calls, API calls, or page rendering.


Let's now create a new directory for our project:

```
mkdir -p $HOME/projects/memcached-operator
```{{execute}}
<br>
Navigate to the directory:

```
cd $HOME/projects/memcached-operator
```{{execute}}
<br>
Create a new Helm-based Operator SDK project for the Memcached Operator:

```
operator-sdk init --plugins helm --domain example.com
```{{execute}}

<br>
For Helm-based projects, `operator-sdk` init also generates the RBAC rules in `config/rbac/role.yaml` based on the resources that would be deployed by the chart’s default manifest. Be sure to double check that the rules generated in `config/rbac/role.yaml` meet the operator’s permission requirements.

To learn more about the project directory structure, see the [project layout](https://sdk.operatorframework.io/docs/overview/project-layout) doc.

** Use an existing chart **

Instead of creating your project with a boilerplate Helm chart, you can also use `--helm-chart`, `--helm-chart-repo`, and `--helm-chart-version` to use an existing chart, either from your local filesystem or a remote chart repository.

<br>
Automatically fetch the Memcached Helm Chart and generate the CRD/API:

```operator-sdk create api --helm-chart memcached --helm-chart-repo=https://charts.helm.sh/stable```{{execute}}
<br>
### Project Scaffolding Layout

After creating a new operator project the directory has numerous generated folders and files. The following
table describes a basic rundown of each generated file/directory.

| File/Folders   | Purpose                           |
| :---           | :--- |
| config | Kustomize YAML definitions required to launch our controller on a cluster. It is the target directory to hold our CustomResourceDefinitions, RBAC configuration, and WebhookConfigurations.
| Dockerfile | The container build file used to build your Ansible Operator container image. |
| helm-charts | The location for the specified helm-charts. |
| Makefile | Make targets for building and deploying your controller. |
| PROJECT | Kubebuilder metadata for scaffolding new components. |
| watches.yaml | Contains Group, Version, Kind, and desired chart. |
