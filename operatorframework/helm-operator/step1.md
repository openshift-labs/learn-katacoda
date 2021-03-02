Let's begin my creating a new project called `myproject`:

```
oc new-project myproject
```{{execute}}

CockroachDB is a database so let's ensure we have accessible persistent storage by adding some current `PersistentVolumes` to a `StorageClass` called `local-storage`:

```
for num in {02..06}; do oc patch pv pv00$num --type='json' -p '[{"op": "replace", "path": "/spec/storageClassName", "value":local-storage}]'; done;
```{{execute}}
<br>
Let's now create a new directory for our project:

```
mkdir -p $HOME/projects/cockroachdb-operator
```{{execute}}
<br>
Navigate to the directory:

```
cd $HOME/projects/cockroachdb-operator
```{{execute}}
<br>
Create a new Helm-based Operator SDK project for the CockroachDB Operator:

```
operator-sdk init --plugins=helm --domain example.com
```{{execute}}
<br>
Automatically fetch the Cockroachdb Helm Chart and generate the CRD/API:

```operator-sdk create api --helm-chart=cockroachdb --helm-chart-repo=https://charts.helm.sh/stable --helm-chart-version=3.0.7```{{execute}}
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
