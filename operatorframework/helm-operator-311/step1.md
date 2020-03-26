Let's begin my creating a new project called `myproject`:

```
oc new-project myproject
```{{execute}}
<br>
Let's now create a new directory in our `$GOPATH/src/` directory:

```
mkdir -p $GOPATH/src/github.com/redhat/
```{{execute}}
<br>
Navigate to the directory:

```
cd $GOPATH/src/github.com/redhat/
```{{execute}}
<br>
Create a new Helm-based Operator SDK project for the CockroachDB Operator:

```
operator-sdk new cockroachdb-operator --type=helm --helm-chart cockroachdb --helm-chart-repo https://kubernetes-charts.storage.googleapis.com
```{{execute}}
<br>
Navigate to the top-level project directory:

```
cd cockroachdb-operator
```{{execute}}
<br>
#### Project Scaffolding Layout

After creating a new operator project using `operator-sdk new --type helm`, the project directory has numerous generated folders and files. The following table describes a basic rundown of the generated files and directories:

| File/Folders | Purpose |
| :---         | :---    |
| deploy | Contains a generic set of Kubernetes manifests for deploying this operator on a Kubernetes cluster. |
| helm-charts/<kind> | Contains a Helm chart initialized using the equivalent of [`helm create`][docs_helm_create] |
| build | Contains scripts that the operator-sdk uses for build and initialization. |
| watches.yaml | Contains Group, Version, Kind, and Helm chart location. |
