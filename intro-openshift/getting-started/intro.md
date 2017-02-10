In this self paced tutorial you will learn how to use the OpenShift Container Platform to build and deploy applications using both containers and orchestration.

## Let's get started

If you are not familiar with the OpenShift Container Platform, it's worth taking a few minutes to understand the basics of the platform as well as the environment that you will be using for this self paced tutorial.  

The goal of OpenShift is to provide a great experience for both Developers and System Administrators to develop, deploy, and run containerized applications.  Developers should love using OpenShift because it enables them to take advantage of both containerized applications and orchestration without having the know the details.  Developers are free to focus on their code instead of spending time writing Dockerfiles and running docker builds.
  
OpenShift is a full platform that incorporates several upstream projects while also providing additional features and functionality to make those upstream projects easier to consume.  The core of the platform is containers and orchestration.  For the container side of the house, the platform uses images based upon the docker image format.  For the orchestration side, we have a put a lot of work into the upstream Kubernetes project.  Beyond these two upstream projects, we have created a set of additional Kubernetes objects such as routes and deployment configs that we will learn how to use during this course.  


Both Developers and Operators communicate with the OpenShift Platform via one of the following methods:

### Command Line Interface

The command line tool that we will be using as part of this training is called the *oc* tool.  This tool is written in the Go programming language and is a single executable that is provided for Windows, OS X, and the Linux Operating Systems.

### Web Console

OpenShift also provides a feature rich Web Console that provides a friendly graphical interface for interacting with the platform.

### REST API

Both the command line tool and the web console actually communicate to OpenShift via the same method, the REST API.  Having a robust API allows users to create their own scripts and automation depending on their specific requirements.  For detailed information about the REST API, check out the official documentation at: https://docs.openshift.org/latest/rest_api/index.html

During this training, you will be using both the command line tool and the web console.  However, it should be noted that there are plugins for several integrated development environments as well.  For example, to use OpenShift from the Eclipse IDE, you would want to use the official [https://tools.jboss.org/features/openshift.html](JBoss Tools) plugin.

### The Environment

During this training course you will be using a hosted OpenShift environment that is created just for you.  This environment is not shared with other users of the system.  Because each user taking this training has their own environment, we had to make some concessions to ensure the overall platform is stable and used only for this training.  For that reason, your environment will only be active for a one hour period.  Keep this in mind before embarking on getting through the content.  Each time you start this training, a new environment will be created on the fly.
 
The OpenShift environment that has been created for you is running the latest version of our open source project called OpenShift Origin.  This deployment is a self contained environment that provides everything you need to be successful in learning the platform.  This includes such things as the command line, web console, and public URLs.

With that being said, grab your favorite choice of beverage and let's do this!
