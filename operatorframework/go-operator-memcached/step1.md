Let's begin by creating a new project called `myproject`:

```
oc new-project myproject
```{{execute}}
<br>
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
Initialize a new Go-based Operator SDK project for the Memcached Operator:

```
operator-sdk init --domain example.com --repo github.com/example/memcached-operator
```{{execute}}
