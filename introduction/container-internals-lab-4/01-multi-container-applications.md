The goal of this exercise is to build a containerized two tier application in the OpenShift cluster. This application will help you learn about clustered containers and distributed systems. It will teach you about Kubernetes and how it operates with the principles of "defined state" and "actual state" - it contantly monitors the environment and attempts to make the acual state match the defined state.

Before we do anything, we need some application images for MySQL and HTTPD/PHP. To do this, we are going to build the supply chain again:

``make -C ~/assets/exercise-01-a/``{{execute}}

In Kuberntes/OpenShifti, applications are defined with either JSON or YAML files - either file format can be imported or exported, even converting between the two. In this lab, we will use YAML files.

Essentially, the appication definition files are a collection of software defined objects in Kuberntes. The objects in the file are imported and become defined state for the application. Important objects include:

- Pods: Collections of one or more containers
- ReplicationControllers: Ensure that the correct number of pods are running.
- Services: Internal object which represents the port/daemon/program running.
- Routes: Expose services to the external world.
- PeristentVolumeClaims: Represents the request for storage and how much. Typically defined in the application by the developer or architect.
- PersistentVolume: Represents the actual storage. Typically defined by sysadmins or automation.

Having of these objects defined in a single file makes sharing and deployment of the entire application easier. These definitions can be stored in version control systems just like code.

Notice there are two Services defined - one for MySQL and one for Wordpress. This allows these two Services to scale independently. The front end can scale with web traffic demand. The MySQL service could also be made to scale with a technology like Galera, but would require special care. You may also notice that even though there are two Services, there is only a single Route in this definition. That's because Services are internal to the Kubernetes cluster, while Routes expose the service externally. We only want to expose our Web Server externally, not our Database:

``cat ~/assets/exercise-01-b/wordpress-objects.yaml``{{execute}}


Once the builds from above complete, let's create this two-tier application:

``oc create -f ~/assets/exercise-01-b/wordpress-objects.yaml``{{execute}}


Look at the status of the application. The two pods that make up this application will remain in a "pending" state - why?

``oc describe pod wordpress-``{{execute}}

``oc describe pod mysql-``{{execute}}


That's because Kubernetes/OpenShift can't make the defined state and actual state match until there is storage available. Inspect the persistent volume claims:

``oc get pvc``{{execute}}


The application needs storage for the MySQL tables, and Web Root for Apache. Let's inspect the YAML file which will create the storage. We will create four persistent volumes - two that have 1GB of storage and two that will have 2GB of storage. In this lab environment, these perisistent volumes will reside on the local all-in-one installation, but in a productoin environment they could reside on shared storage and be accessed from any node in the Kubernetes/OpenShift cluster. This could be Gluster, Ceph, AWS EBS Volumes, NFS, iSCSI, etc:

``cat ~/assets/exercise-01-b/persistent-volumes.yaml``{{execute}}


Instantiate the peristent volumes:

``oc create -f ~/assets/exercise-01-b/persistent-volumes.yaml``{{execute}}


Now, the persistent volume claims for the application will become Bound and satisfy the storage requirements. Kubernetes/OpenShift will now start to converge the defined state and the actual state:

``oc get pvc``{{execute}}


Now look at the status of the pods again:

``oc describe pod mysql-``{{execute}}

``oc describe pod wordpress-``{{execute}}


You may notice the wordpress pod enter a state called CrashLoopBackOff. This is a natural state in Kubernetes/OpenShift which helps satisfy dependencies. The wordpress pod will not start until the mysql pod is up and running. This makes sense, because wordpress can't run until it has a database and a connection to it. Similar to email retries, Kubernetes will back off and attempt to restart the pod again after a short time. Kubernetes will try several times, extending the time between tries until eventually the dependency is satisfied, or it enters an Error state. Luckily, once the mysql pod comes up, wordpress will come up successfully. Here are some useful commands to watch the state:

Show all pods:

``oc get pods``{{execute}}

View the events for a pod:

``oc describe pod mysql-``{{execute}}

``oc describe pod wordpress-``{{execute}}

View the terminal output for a pod:

``oc logs $(oc get pods | grep mysql- | awk '{print $1}')``{{execute}}

``oc logs $(oc get pods | grep wordpress- | awk '{print $1}')``{{execute}}


Log into the OpenShift web interface which is a convenient place to monitor the state, and troublshoot things when they go wrong. You can even get a debug terminal into a Pod to troublshoot if it crashes. This can help you figure out why it crashed. This shouldn't happen in this lab, but as you build applications it surely will :-)

* Username: `admin`{{copy}}
* Password: `admin`{{copy}}
* Console: [here](https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/default/browse/builds)

Here are some useful locations to investigate what is happening. The "Events" section is useful early in the Pod creation process, when its being scheduled in the cluster and then when the container image is being pulled. Later in the process when a Pod is crashing because of something in the container image itself, its useful to watch the terminal output in the "Logs" section. It can also be useful to run commands live in a Terminal. Sometimes a Pod won't start, so it's useful poke around with using the "Debug in Terminal" section. Get a feel in the following areas of the interface:

- Applications -> Pods -> mysql-##### -> Events 
- Applications -> Pods -> mysql-##### -> Logs
- Applications -> Pods -> mysql-##### -> Terminal
- Applications -> Pods -> mysql-##### -> Details -> Debug in Terminal
- Applicaitons -> Pods -> wordpress-##### -> Events
- Applicaitons -> Pods -> wordpress-##### -> Logs
- Applicaitons -> Pods -> wordpress-##### -> Terminal
- Applicaitons -> Pods -> wordpress-##### -> Details -> Debug in Terminal



Finally, ensure that the web interface is up and running. We will need this for the next lab:

``curl http://$(oc get svc | grep wpfrontend | awk '{print $2}')/wp-admin/install.php``{{execute}}


In this exercise you learned how to deploy a fully functional two tier application with a single command (oc create). As long as the cluster has peristnet volumes available to satisify the application, an end user can do this on their laptop, in a development environment or in production data centers all over the world. All of the dependent code is packaged up and delivered in the container images - all of the data and configuration comes from the environment. Production instances will access production persistent volumes, development environments can be seeded with copies of production data, etc. It's easy to see why container orchestration is so powerful. 
