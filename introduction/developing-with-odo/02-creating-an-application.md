As mentioned, applications often consist of two or more components that work together to implement the overall application. OpenShift helps organize these modular applications with a concept called, appropriately enough, the application. An OpenShift application represents all of an app's components in a logical management unit. The `odo` tool helps you manage that group of components and link them together, as an application.


First, we create an application to work with. We will name our application `wildwest`. Go back to the Terminal tab and enter:

`odo app create wildwest`{{execute}}

You can list the applications `odo` is managing using:

`odo app list`{{execute}}

You should see output that looks similar to this:

```
The project 'myproject' has the following applications:
ACTIVE     NAME
*          wildwest
```

Since we began with an empty environment, only the `wildwest` application is listed.
