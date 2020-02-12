For this tutorial, you're going to use a simple Node.js application that interacts with a MongoDB database. This application needs to deploy in a new project (i.e. Kubernetes namespace). You can start by creating the project with:

`oc new-project lab-tekton`{{execute}}

For this tutorial, you will deploy the _nodejs-ex_ sample application from the [sclorg](https://github.com/sclorg) repository.

To prepare for _nodejs-ex _'s eventual deployment, you create Kubernetes objects that are supplementary to the application, such as a route (i.e. URL). The deployment will not complete since there are no container images built for the _nodejs-ex_ application yet. You will complete this deployment in the following sections through a CI/CD pipeline.

Create the supplementary Kubernetes objects by running the command below:

`oc create -f sampleapp/sampleapp.yaml`{{execute}}

_nodejs-ex_ also needs a MongoDB database. You can deploy a container with MongoDB to your OpenShift project by running the following command:

`oc new-app centos/mongodb-36-centos7 -e MONGODB_USER=admin MONGODB_DATABASE=mongodb MONGODB_PASSWORD=secret MONGODB_ADMIN_PASSWORD=super-secret`{{execute}}

You should see `--> Success` in the output of the command, which verifies the successful deployment of the container image.

The command above uses a container image with a CentOS 7 operating system and MongoDB 3.6 installed. It also sets environment variables using the -e option. MongoDB needs these environment variables for its deployment, such as the username, database name, password, and the admin password.

A service is an abstract way to expose an application running on a set of pods as a network service. Using a service name allows _nodejs-ex_ to reference a consistent endpoint in the event the pod hosting your MongoDB container is updated from events such as scaling pods up or down or redeploying your MongoDB container image with updates.

You can see all the services, including the one for _nodejs-ex_ in your OpenShift project by running the following command:

`oc get services`{{execute}}

Now that you are familiar with Kubernetes services go ahead and connect _nodejs-ex_ to the MongoDB. To do this, set the connection string in an environment variable by running the following command:

`oc set env dc/nodejs-ex MONGO_URL="mongodb://admin:secret@mongodb-36-centos7:27017/mongodb"`{{execute}}

## Verify the deployment

To verify the creation of the resources needed to support _nodejs-ex_ and the MongoDB, you can head out to the OpenShift web console.

You can make your way to the web console by clicking on the Console tab next to the Terminal tab at the center top of the workshop in your browser.

You need to log in with username `admin` and password `admin`.

Make sure the Developer option from the dropdown in the top left corner of the web console is selected as shown below:

<img src="../../assets/middleware/pipelines/developer-view.png" width="800" />

Next, select the Project dropdown menu shown below and choose the project namespace you have been working with (_lab-tekton_). 

Next, click on the Topology tab on the left side of the web console if you don't see what's in the image below. Once in the Topology view, you can see the deployment config for the _nodejs-ex_ application and the MongoDB, which should look similar to the image below:

<img src="../../assets/middleware/pipelines/topology-view.png" width="800" />

You'll notice the white circle around the _nodejs-ex_ deployment config. This highlight means that the _nodejs-ex_ application isn't running yet. More specifically, no container hosting the _nodejs-ex_ application has been created, built, and deployed yet.

The _mongodb-36-centos7_ deployment config has a dark blue circle around it, meaning that a pod is running with a MongoDB container on it. The MongoDB should be all set to support the _nodejs-ex_ application at this point.

In the next section, you'll learn how to use Tekton tasks.