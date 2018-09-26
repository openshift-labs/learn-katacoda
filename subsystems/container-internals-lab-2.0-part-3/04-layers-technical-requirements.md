Using containers is as much a business advantage as a technical one.  When building and using containers, everything is about layering.  You want to look at your application and think about each of the pieces and how they work together.  Similar to the way you can break up a program into a series of classes and functions.  Containers are made up of packages and scripts that combine with other containers to build your application. So approach containers with the mindset that your application is made up of smaller units and the packaging of those units into something easily consumable will make your containerized application.

The purpose of layering is to provide a thin level of abstraction above the previous layer to build something more complex.  Layers are logical units where the contents are the same type of object or perform a similar task. The right amount of layers will make your container easily consumable.  Too many layers will be too complex and too little, difficult to consume. The proper amount of layers for an application should reflect the complexity of your application.  The more complex the application, the more layers and vice versa. For example, if a Hello World container prints to stdout “Hello World” there’s no configuration, no process management, and no dependencies, so it’s a single layer.  However, if we expand the Hello World application to say hello to the user, we will need a second layer to gather input.

To demonstrate the layered approach, we are going to inspect a simple three tier supply chain with a core build two different pieces of middleware (Ruby and PHP) and an example application (WordPress). This will demonstrate how development and operations collaborate, yet maintain separation of concerns, to build containers and make user space changes, over time, in the container image to deliver applications which can easily be updated when needed.

This exercise has subdirectories which contain a Dockerfile for each layer. Take a look at each one and notice the separation of concerns between development and operations. Pay particular attention to the FROM directive in each file:

``for i in ~/labs/lab2-step4/*/Dockerfile; do less $i; done``{{execute}}

Initiate a single node build with all of the Dockerfiles using the Makefile. Watch the output - notice the yum updates and installs that are happening. Also, notice that the corebuild is built before any of the other layers:

``make -C ~/labs/lab2-step4/``{{execute}}

Now, inspect the images which were built:

``docker images``{{execute}}


``wordpress                                                   latest              0257c101e2b3        4 minutes ago       294.7 MB
httpd-ruby                                                  latest              99aace3c31f2        16 minutes ago      338.6 MB
httpd-php                                                   latest              7b7f6eefa4ec        19 minutes ago      273.8 MB
corebuild                                                   latest              f87d9be15b22        22 minutes ago      207.8 MB``

Now, initiate a distributed build on the OpenShift cluster. The yaml file below will create everything you need. Once the builds complete, the images will be placed in the OpenShift registry and are usable in the cluster:

``oc new-project lab2-step4``{{execute}}

``oc create -f ~/labs/lab2-step4/AutomaticSupplyChain.yaml``{{execute}}

Inspect the builds in the web interface. The build will start automatically after submitting the yaml file to the Kubernetes API daemon. Inspect the actual build by clicking on the "#1" then the "Logs" and "Events" sections. Notice how the OpenShift BuildConfigs cause cascading builds to automatically happen and distributes the builds to the cluster. Feel free to explore the different sections of the web interface, especially the "Applications -> Pods" and "Builds -> Builds" sections.

* Username: `admin`{{copy}}
* Password: `admin`{{copy}}
* Console: [here](https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/lab02-exercise04/browse/builds)

Now, inspect the corebuild with the command line. When the core build completes, inspect some of the dependent builds. Pay particular attention to the "Node:" and "Events:" sections

``oc get builds``{{execute}}

``oc describe pod corebuild-1-build``{{execute}}


OpenShift creates data structures which point to these images and can now be used to build (BuildConfigs) and deploy (DeploymentConfigs) other applications within OpenShift. These are very powerful automation tools:

``oc get is``{{execute}}

Finally, notice that these images are available in the local docker cache. Kubernetes/OpenShift builds on top of Docker, but you still have access to the lower level tooling:

``docker images``{{execute}}
