ConfigMaps can be created in a few different ways. For this example we will use the **oc** command to create
a ConfigMap based on the contents of the `app-config.yml` file included as part of the sample application.

**1. Assign permissions**

Applications needing to access ConfigMaps need permission to do so. Click on the below command to grant
access to the application:

```oc policy add-role-to-user view -n $(oc project -q) -z default```{{execute}}

**2. Create ConfigMap using `oc`**

Click on the below command to create the ConfigMap object. Since you're still logged into OpenShift, and
currently in the `example` project, the ConfigMap will be created there, and accessible from applications
running within this project.

```oc create configmap app-config --from-file=app-config.yml```{{execute}}

The name `app-config` is the same name as is used in the code in `app.js` to access the ConfigMap at runtime.

**3. Verify your ConfigMap configuration has been deployed**

```oc describe cm app-config```{{execute}}

> NOTE: `cm` is shorthand for `configmap`

You should see the contents of the ConfigMap in the terminal window:

```console
Name:           app-config
Namespace:      example
Labels:         <none>
Annotations:    <none>

Data
====
app-config.yml:
----
message : "Hello, %s from a ConfigMap !"

Events: <none>
```

The `Data` values of the ConfigMap contains key/value pairs, in this case a key of `app-config.yml` (derived from the
name of the file from which the ConfigMap was initialized) which contains
the configuration values. At runtime, the code you wrote in the last step accesses the ConfigMap using these names
to read the content (in this case, the `message` value that we use in the app to customize the returned message at
runtime).

Now that you have the application coded to read the ConfigMap, and have created the ConfigMap, it's time to re-deploy
the application and test out our new functionality.
