As mentioned before, applications often consist of two or more components that work together to provide useful functions. OpenShift helps organize these modular applications with a concept called, appropriately enough, the *Application*. An OpenShift Application represents all of an app's components in a logical management unit. The `odo` tool groups the components that implement your app's features into OpenShift Applications.

First, we create an Application to work with. We name our Application `sample`:

`odo app create sample`{{execute}}

Now we can list the applications `odo` knows about:

`odo app list`{{execute}}

Since we began with an empty environment, only the `sample` application is listed.
