# Lab 4 Exercises
Get into the right directory
```
cd /root/work/container-internals-lab/labs/lab-04/
```



## Exercise 1
The goal of this exercise is to build a containerized two tier application in the OpenShift cluster. This application will help you learn about clustered containers and distributed systems


First, inspect the application that we are going to create. We will start with the definition of the application itself. Notice the different software defined objects we are going to create - Services, ReplicationControllers, Routes, PeristentVolumeClaims. All of these objects are defined in a single file to make sharing and deployment of the entire application easy. These definitions can be stored in version control systems just like code. With Kubernetes these application definition files can be written in either JSON or YAML. 

Notice, there is only a single Route in this definition. That's because Services are internal to the Kubernetes cluster, while Routes expose the service externally. We only want to expose our Web Server externally, not our Database:
```
vi exercise-01/wordpress-objects.yaml
```

Now, let's create an application:
```
oc create -f exercise-01/wordpress-objects.yaml
```

Look at the status of the application. The two pods that make up this application will remain in a "pending" state - why?
```
oc describe pod wordpress-
oc describe pod mysql-
```

Inspect the persistent volume claims:
```
oc get pvc
```

The application needs storage for the MySQL tables, and Web Root for Apache. Let's inspect the yaml file which will create the storage. We will create four persistent volumes - two that have 1GB of storage and two that will have 2GB of storage. These perisistent volumes will reside on the storage node and use NFS:
```
vi exercise-01/persistent-volumes.yaml
```

Instantiate the peristent volumes:
```
oc create -f exercise-01/persistent-volumes.yaml
```

Now, the persistent volume claims for the application will become Bound and satisfy the storage requirements:
```
oc get pvc
```

Now look at the status of the pods again:
```
oc describe pod wordpress-
oc describe pod mysql-
```

You may notice the wordpress pod enter a state called CrashLoopBackOff. This is a natural state in Kubernetes/OpenShift which helps satisfy dependencies. The wordpress pod will not start until the mysql pod is up and running. This makes sense, because wordpress can't run until it has a database and a connection to it. Similar to email retries, Kubernetes will back off and attempt to restart the pod again after a short time. Kubernetes will try several times, extending the time between tries until eventually the dependency is satisfied, or it enters an Error state. Luckily, once the mysql pod comes up, wordpress will come up successfully.
```
oc describe pod wordpress-
```

Visit the web interface and run through the wordpress installer:
```
http://wpfrontend-wordpress.apps.example.com/
```

In this exercise you learned how to deploy a fully functional two tier application with a single command (oc create -f excercise-01/wordpress-objects.yaml). As long as the cluster has peristnet volumes available to satisify the application, an end user can do this on their laptop, in a development environment or in production data centers all over the world. All of the dependent code is packaged up and delivered in the container images - all of the data and configuration comes from the environment. Production instances will access production persistent volumes, development environments can be seeded with copies of production data, etc. It's easy to see why container orchestration is so powerful. 



## Exercise 2
In this exercise, you will scale and load test a distributed application

Test with AB before we scale the application to get a base line. We will run this command from the privileged rhel-tools container on the master node:
```
ab -n100 -c 10 -k -H "Accept-Encoding: gzip, deflate" http://wpfrontend-wordpress.apps.example.com/
```

Scale in interface. Click the up arrow and scale to 3 nodes:
```
https://ose3-master.example.com:8443/console/project/lab02-exercise04/overview
```

Test with AB. The response time should now be lower.
```
ab -n100 -c 10 -k -H "Accept-Encoding: gzip, deflate" http://wpfrontend-wordpress.apps.example.com/
```

Scale with command line. Run the follwing command to scale with the command line:
```
oc scale --replicas=5 rc/wordpress
```

Test with AB. The response time should now be even lower.
```
ab -n100 -c 10 -k -H "Accept-Encoding: gzip, deflate" http://wpfrontend-wordpress.apps.example.com/
```

Scale the application back down to one pod:
```
oc scale --replicas=1 rc/wordpress
```


## Exercise 3
The goal of this exercise is to understand the nature of a distributed systems environment with containers. Quickly and easily troubleshooting problems in containers requires distributed systems thinking. You have to think of things programatically. You can't just ssh into a server and understand the problem. You can execute commands in a sinlge pod, but even that might prevent you from troubleshooting things like network, or database connection errrors which are specific to only certain pods. This can happen because of persnickety differences in locations of your compute nodes in a cloud environment or code that only fails in unforseen ways at scale or under load. 

We are going to simulate one of these problems by using a specially designed test application. In this exercise we will learn how to figure things out quickly and easily.

Inspect each of the files and try to understand them a bit:
```
vi exercise-03/Build.yaml
```
```
vi exercise-03/Run.yaml
````

Build the test application. Wait for the build to successfully complete. You can watch the log output in the OpenShift web interface.
```
oc create -f exercise-03/Build.yaml
```
```
oc get builds
```

Run the test application
```
oc create -f exercise-03/Run.yaml
```

Get the IP address for the goodbad service
```
oc get svc
```

Now test the cluster IP with curl. Use the cluster IP address so that the traffic is balanced among the active pods. You will notice some errors in your responses. You may also test with a browser. Some of the pods are different - how could this be? They should be identical because they were built from code right?
```
SVC_IP=`oc get svc | grep goodbad | awk '{print $2}'`
for i in {1..20}; do curl $SVC_IP; done
```

Example output:
```
<html>
 <head>
  <title>PHP Test</title>
 </head>
 <body>
 <p>ERROR</p> </body>
</html>
<html>
 <head>
  <title>PHP Test</title>
 </head>
 <body>
 <p>Hello World</p> </body>
</html>
<html>
 <head>
  <title>PHP Test</title>
 </head>
 <body>
 <p>Hello World</p> </body>
</html>
```

Take a look at the code. A random number is generated in the entrypoint and written to a file in /var/www/html/goodbad.txt:
```
cat exercise-03/index.php
cat exercise-03/Dockerfile
```

Troubleshoot the problem in a programatic way. Notice some pods have files which contian numbers that are lower than 7, this means the pod will return a bad response:
```
for i in `oc get pods | grep goodbad | grep -v build | awk '{print $1}'`; do oc exec -t $i -- cat /var/www/html/goodbad.txt; done
```

Continue to troubleshoot the problem by temporarily fixing the file
```
for i in `oc get pods | grep goodbad | grep -v build | awk '{print $1}'`; do oc exec -t $i -- sed -i -e s/[0-9]*/7/ /var/www/html/goodbad.txt; done
```

Write a quick test that verifies the logic of your fix
```
for i in {1..2000}; do curl $SVC_IP 2>&1; done | grep "Hello World" | wc -l
```

Scale up the nodes, and test again. Notice it's broken again because new pods have been added with the broken file
```
oc scale rc goodbad --replicas=10
for i in {1..2000}; do curl $SVC_IP 2>&1; done | grep "Hello World" | wc -l
```

Optional: As a final challenge, fix the problem permanently by fixing the logic so that the number is always above 7 and never causes the application to break. Rebuild, and redeploy the applicaion. Hint: you have to get the images to redeploy with the newer versions (delete the rc) :-)


