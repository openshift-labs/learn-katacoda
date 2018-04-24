We start by listing all the possible components availbale ATM

`odo catalog list`{{execute}}

```
The following components can be deployed:
- httpd
- nodejs
- perl
- php
- python
- ruby
- wildfly
```

Then we switch to backend source code repo

`cd ~/backend`{{execute}}

there is a simple Java application, we need to build it to get the deployment
artifact `ROOT.war`

`mvn package`{{execute}}

Now, let's create the component

`odo create wildfly backend --binary=target/ROOT.war`{{execute}}

You will see no output while the platform is deploying your artifact, but
eventually you will see

``
Receiving source from STDIN as file ROOT.war
Moving binaries in source directory into /wildfly/standalone/deployments for later deployment...
Moving all war artifacts from /opt/app-root/src/. directory into /wildfly/standalone/deployments for later deployment...
'/opt/app-root/src/./ROOT.war' -> '/wildfly/standalone/deployments/ROOT.war'
Moving all ear artifacts from /opt/app-root/src/. directory into /wildfly/standalone/deployments for later deployment...
Moving all rar artifacts from /opt/app-root/src/. directory into /wildfly/standalone/deployments for later deployment...
Moving all jar artifacts from /opt/app-root/src/. directory into /wildfly/standalone/deployments for later deployment...
...done

Pushing image 172.30.144.245:5000/myproject/backend:latest ...
Pushed 0/12 layers, 2% complete
Pushed 1/12 layers, 25% complete
Pushed 2/12 layers, 17% complete
Pushed 3/12 layers, 26% complete
Pushed 4/12 layers, 34% complete
Pushed 5/12 layers, 42% complete
Pushed 6/12 layers, 51% complete
Pushed 7/12 layers, 59% complete
Pushed 8/12 layers, 68% complete
Pushed 9/12 layers, 90% complete
Pushed 10/12 layers, 97% complete
Pushed 11/12 layers, 98% complete
Pushed 12/12 layers, 100% complete
Push successful
Component 'backend' was created.

Component 'backend' is now set as active component.
``

which means the application is successfully deployed in OpenShift.

Not, let's verify by running

`odo list`{{execute}}

which will report there is one component

``
ACTIVE     NAME        TYPE
*          backend     wildfly
``
