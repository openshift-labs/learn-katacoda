The goal of this exercise is to build a containerized two tier application in the OpenShift cluster. This application will help you learn about clustered containers and distributed systems

Before we do anything, we need some application images for MySQL and HTTPD/PHP. To do this, we are going to build the supply chain again:

``oc create -f ~/assets/exercise-04/AutomaticSupplyChain.yaml``{{execute}}

Inspect the builds in the web interface. The build will start automatically after submitting the yaml file to the Kubernetes API daemon. Inspect the actual build by clicking on the "#1" then the "Logs" and "Events" sections. Notice how the OpenShift BuildConfigs cause cascading builds to automatically happen and distributes the builds to the cluster. Feel free to explore the different sections of the web interfece, especially the "Applications -> Pods" and "Builds -> Builds" sections.

* Username: `admin`{{copy}}
* Password: `admin`{{copy}}
* Console: [here](https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/lab02-exercise04/browse/builds)

Inspect the application that we are going to create. We will start with the definition of the application itself. Notice the different software defined objects we are going to create - Services, ReplicationControllers, Routes, PeristentVolumeClaims. All of these objects are defined in a single file to make sharing and deployment of the entire application easy. These definitions can be stored in version control systems just like code. With Kubernetes these application definition files can be written in either JSON or YAML. 

Notice, there is only a single Route in this definition. That's because Services are internal to the Kubernetes cluster, while Routes expose the service externally. We only want to expose our Web Server externally, not our Database:

``vi ~/assets/exercise-01/wordpress-objects.yaml``{{execute}}


Now, let's create an application:

``oc create -f ~/assets/exercise-01/wordpress-objects.yaml``{{execute}}


Look at the status of the application. The two pods that make up this application will remain in a "pending" state - why?

``oc describe pod wordpress-``{{execute}}

``oc describe pod mysql-``{{execute}}


Inspect the persistent volume claims:

``oc get pvc``{{execute}}


The application needs storage for the MySQL tables, and Web Root for Apache. Let's inspect the yaml file which will create the storage. We will create four persistent volumes - two that have 1GB of storage and two that will have 2GB of storage. These perisistent volumes will reside on the storage node and use NFS:

``vi ~/assets/exercise-01/persistent-volumes.yaml``{{execute}}


Instantiate the peristent volumes:

``oc create -f ~/assets/exercise-01/persistent-volumes.yaml``{{execute}}


Now, the persistent volume claims for the application will become Bound and satisfy the storage requirements:

``oc get pvc``{{execute}}


Now look at the status of the pods again:

``oc describe pod wordpress-``{{execute}}

``oc describe pod mysql-``{{execute}}


You may notice the wordpress pod enter a state called CrashLoopBackOff. This is a natural state in Kubernetes/OpenShift which helps satisfy dependencies. The wordpress pod will not start until the mysql pod is up and running. This makes sense, because wordpress can't run until it has a database and a connection to it. Similar to email retries, Kubernetes will back off and attempt to restart the pod again after a short time. Kubernetes will try several times, extending the time between tries until eventually the dependency is satisfied, or it enters an Error state. Luckily, once the mysql pod comes up, wordpress will come up successfully.

``oc describe pod wordpress-``{{execute}}


Visit the web interface and run through the wordpress installer:

``links http://$HOSTNAME``{{execute}}


In this exercise you learned how to deploy a fully functional two tier application with a single command (oc create -f excercise-01/wordpress-objects.yaml). As long as the cluster has peristnet volumes available to satisify the application, an end user can do this on their laptop, in a development environment or in production data centers all over the world. All of the dependent code is packaged up and delivered in the container images - all of the data and configuration comes from the environment. Production instances will access production persistent volumes, development environments can be seeded with copies of production data, etc. It's easy to see why container orchestration is so powerful. 
