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
operator-sdk init --domain=example.com --repo=github.com/redhat/memcached-operator
```{{execute}}

Now, let's take a look at the project that's scalfolded by operator-sdk and observe these directories, a, b, c.

```
tree
```{{execute}}

We should see the operator scaffolded