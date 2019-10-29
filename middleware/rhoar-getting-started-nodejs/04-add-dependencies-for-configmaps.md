## What is a ConfigMap?

ConfigMap is an object used by OpenShift to inject configuration data as simple key and value pairs into one or
more Linux containers while keeping the containers agnostic of OpenShift. You can create a ConfigMap object in a
variety of different ways, including using a YAML file, and inject it into the Linux container. You can find more
information about ConfigMap in the [OpenShift documentation](https://docs.openshift.org/latest/dev_guide/configmaps.html).

## Why ConfigMap is Important

It is important for an application’s configuration to be externalized and separate from its code. This allows for
the application’s configuration to change as it moves through different environments while leaving the code unchanged.
This also keeps sensitive or internal information out of your codebase and version control. Many languages and
application servers provide environment variables to support externalizing an application’s configuration.
Microservices and Linux containers increase the complexity of this by adding pods, or groups of containers representing
a deployment, and polyglot environments. ConfigMaps enable application configuration to be externalized and used
in individual Linux containers and pods in a language agnostic way. ConfigMaps also allow sets of configuration
data to be easily grouped and scaled, which enables you to configure an arbitrarily large number of environments
beyond the basic Dev, Stage, and Production.

## Design Tradeoffs

**Pros**

* Configuration is separate from deployments
* Can be updated independently
* Can be shared across services

**Cons**

* Configuration is separate from deployments
* Has to be maintained separately
* Requires coordination beyond the scope of a service

Notice the first Pro is also the first Con. Separating configuration is generally a good practice for cloud native
applications, but it does come at some cost. However the pros far outweigh the cons as explained earlier. Let's modify
the sample app to separate its config using OpenShift ConfigMaps!

**Add NPM modules for ConfigMap support**

The [NPM package ecosystem](https://www.npmjs.com/) contains projects that help implement various functionality in Node apps. To enable our
sample Node app to access OpenShift ConfigMaps, you'll need to declare a dependency on a new package.

Execute the following command to insert the new dependencies into the `package.json` file:

```npm install "openshift-rest-client@^2.3.0" --save-prod```{{execute}}

This will download and install the needed dependency and update
the `package.json` file. Close the file (click on the small 'X' near the filename)
and then re-open the file (click here: `package.json`{{open}}) to see the additional dependency added near the bottom of the file.

Using this package the application will be able to access its configuration from OpenShift using a ConfigMap.
But you still need to implement the logic behind that access, which you'll do next.

