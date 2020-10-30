Let's begin by creating a new project called `myproject`:

```
oc new-project myproject
```{{execute}}
<br>
Let's now create a new directory for our project:

```
mkdir -p $HOME/projects/podset-operator
```{{execute}}
<br>
Navigate to the directory:

```
cd $HOME/projects/podset-operator
```{{execute}}
<br>
Initialize a new Go-based Operator SDK project for the PodSet Operator:

```
operator-sdk init --domain=example.com --repo=github.com/redhat/podset-operator
```{{execute}}