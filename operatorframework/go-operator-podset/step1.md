Let's begin by creating a new project called `myproject`:

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
Create a new Go-based Operator SDK project for the PodSet:

```
operator-sdk new podset-operator --type=go
```{{execute}}


<br>
Navigate to the project root:

```
cd podset-operator
```{{execute}}
<br>
