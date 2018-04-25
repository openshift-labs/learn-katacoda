As mentioned before, applications often consist of two or more components that work together to provide useful functions. OpenShift helps organize these modular applications with a concept called, appropriately enough, the Application. An OpenShift Application groups an app's components into a logical management unit. `Odo` uses the Application to hold the component pods that implement your app's features.

First, we create an Application to work within. We name our Application `sample`:

`odo application create sample`{{execute}}

Now we can list the applications `odo` knows about:

`odo application list`{{execute}}
