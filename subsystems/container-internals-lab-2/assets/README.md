# Lab 2 Excercises
Get into the right directory
```
cd /root/work/container-internals-lab/labs/lab-02/
```



## Excercise 1
The goal of this exercise is to understand the difference between base images and multi-layered images (repositories). Also, try to understand the difference between an image layer and a repository.

First, let's take a look at some base images. We will use the docker history command to inspect all of the layers in these repositories. Notice that these container images have no parent layers. These are base images and they are designed to be built upon.
```
docker history rhel7
docker history rhel7-atomic
```

Now, build a multi-layered image:
```
docker build -t rhel7-change exercise-01/
```

Do you see the newly created rhel7-change image?
```
docker images
```

Can you see all of the layers that make up the new image/repository? This command even shows a short summary of the commands run in each layer. This is very convenient for exploring how an image was made.

```
docker history rhel7-change
```

Now run the "dockviz" command. What does this command show you? What's the parent image of the rhel7-change image? It is important to build on a trusted base image from a trusted source (aka have provenance or maintain chain of custody).
```
docker run --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz images -t
```



## Exercise 2
Now we are going to inspect the different parts of the URL that you pull. The most common command is something like this, where only the repository name is specified:

```
docker inspect rhel7
```

But, what's really going on? Well, similar to DNS, the docker command line is resolving the full URL and TAG of the repository on the registry server. The following command will give you the exact same results:
```
docker inspect registry.access.redhat.com/rhel7/rhel:latest
```

You can run any of the following commands and you will get the exact same results as well:
```
docker inspect registry.access.redhat.com/rhel7/rhel:latest
docker inspect registry.access.redhat.com/rhel7/rhel
docker inspect registry.access.redhat.com/rhel7:latest
docker inspect registry.access.redhat.com/rhel7
docker inspect rhel7/rhel:latest
docker inspect rhel7/rhel
```

Now, let's build another image, but give it a tag other than "latest":
```
docker build -t registry.access.redhat.com/rhel7/rhel:test exercise-01/
```

Now, notice there is another tag
```
docker run --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz images -t
```

Now try the resolution trick again. What happened?
```
docker inspect rhel7:test
```

Notice that full resolution only works with the latest tag. You have to specify the namespace and the repository with other tags. There are a lot of caveats to namespace, repository and tag resolution, so be careful. Typically, it's best to use the full URL. Remember this when building scripts.
```
docker inspect rhel7/rhel:test
```



## Exercise 3
In this exercise we will take a look at what's inside the container image. Java is particularly interesting because it uses glibc. The ldd command shows you all of the libraries that a binary is linked against. These libraries have to be on the system, or the binary will not run. In this example, you can see that getting a JVM to run in a particular container, with the exact same behavior, requries having it compiled and linked in the same way.
```
docker run -it registry.access.redhat.com/jboss-eap-7/eap70-openshift ldd -v -r /usr/lib/jvm/java-1.8.0-openjdk/jre/bin/java
```

Notice that dynamic scripting languages are also compiled and linked against system libraries:
```
docker run -it rhel7 ldd /usr/bin/python
```

Inspecting a common tool like "curl" demonstrates how many libraries are used from the operating system. First, start the RHEL Tools container:
```
docker run -it rhel7/rhel-tools bash
```

Take a look at all of the libraries curl is linked against:
```
ldd /usr/bin/curl
```

Let's see what packages deliver those libraries? Both, OpenSSL, and the Network Security Services libraries. When there is a new CVE discovered in either nss or oepnssl, a new container image will need built to patch it.
```
rpm -qf /lib64/libssl.so.10
rpm -qf /lib64/libssl3.so
```

Exit the rhel-tools container:
```
exit
```


It's a similar story with Apache and most other daemons and utilities that rely on libraries for security, or deep hardware integration:
```
docker run -it registry.access.redhat.com/rhscl/httpd-24-rhel7 bash
```

Inspect mod_ssl Apache module:
```
ldd /opt/rh/httpd24/root/usr/lib64/httpd/modules/mod_ssl.so
```

Once again we find a library provided by OpenSSL:
```
rpm -qf /lib64/libcrypto.so.10
```

Exit the httpd24 container:
```
exit
```

What does this all mean? Well, it means you need to be ready to rebuild all of your container images any time there is a security vulnerability in one of the libraries inside one of your container images...



## Optional: Exercise 4
Using containers is as much a business advantage as a technical one.  When building and using containers, everything is about layering.  You want to look at your application and think about each of the pieces and how they work together.  Similar to the way you can break up a program into a series of classes and functions.  Containers are made up of packages and scripts that combine with other containers to build your application. So approach containers with the mindset that your application is made up of smaller units and the packaging of those units into something easily consumable will make your containerized application.

The purpose of layering is to provide a thin level of abstraction above the previous layer to build something more complex.  Layers are logical units where the contents are the same type of object or perform a similar task. The right amount of layers will make your container easily consumable.  Too many layers will be too complex and too little, difficult to consume. The proper amount of layers for an application should reflect the complexity of your application.  The more complex the application, the more layers and vice versa. For example, if a Hello World container prints to stdout “Hello World” there’s no configuration, no process management, and no dependencies, so it’s a single layer.  However, if we expand the Hello World application to say hello to the user, we will need a second layer to gather input.

To demonstrate the layered approach, we are going to inspect a simple three tier supply chain with a core build two different pieces of a middleware (Ruby and PHP) and an example application (wordpress). This will demonstrate how development and operations collaberate, yet maintain separatation of concerns, to build containers and make user space changes, over time, in the container image to deliver applications which can easily be updated when needed.

This exercise has subdirectories which contain a Dockerfile for each layer. Take a look at each one and notice the separation of concerns between development and operations. Pay particular attention to the FROM directive in each file:
```
for i in exercise-04/*/Dockerfile; do less $i; done
```

Initiate a single node build with all of the Dockerfiles using the Makefile. Watch the output - notice the yum updates and installs that are happening. Also, notice that the corebuild is built before any of the other layers:
```
make -C ./exercise-04/
```

Now, inspect the images which were built:
```
docker images
```

```
wordpress                                                   latest              0257c101e2b3        4 minutes ago       294.7 MB
httpd-ruby                                                  latest              99aace3c31f2        16 minutes ago      338.6 MB
httpd-php                                                   latest              7b7f6eefa4ec        19 minutes ago      273.8 MB
corebuild                                                   latest              f87d9be15b22        22 minutes ago      207.8 MB
```

Now, initiate a distributed build on the OpenShift cluster. The yaml file below will create everything you need. Once the builds complete, the images will be placed in the OpenShift registry and are usable in the cluster:
```
oc new-project lab02-exercise04
oc create -f exercise-04/AutomaticSupplyChain.yaml
```

Inspect the builds in the web interface. Notice how the OpenShift BuildConfigs cause cascading builds to automatically happen and distributes the builds to the cluster.
```
https://haproxy1.ocp1.dc2.crunchtools.com:8443/console/project/lab02-exercise04/browse/builds
```

When the core build completes, inspect some of the dependent builds. Pay particular attention to the "Node:" and "Events:" sections
```
oc describe pod wordpress-1-build
oc describe pod httpd-ruby-1-build
```

These images can now be used to build (BuildConfigs) and Deploy (DeploymentConfigs) other applications:
```
oc get is
```
