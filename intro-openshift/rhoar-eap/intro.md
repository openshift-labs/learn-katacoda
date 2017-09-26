In this self paced tutorial you will learn how to use Red Hat® JBoss® Enterprise Application Platform (JBoss EAP) on OpenShift. 
JBoss EAP is built to provide simplified deployment and full Java™ EE performance for applications from large EAR or WAR files
down to microservices. It offers Java web developers the performance, flexibility, and standards they know and love.

JBoss EAP is one of the suite of runtimes available in Red Hat OpenShift Application Runtime (RHOAR) - integrated and tested 
to take advantage of all the benefits OpenShift has to offer. 

## Let's get started

If you are not familiar with the OpenShift Container Platform, it is probably best if you go do the 
[https://learn.openshift.com/introduction/getting-started/](Getting Started) with OpenShift scenario. 

You do not need to install anything on your local machine for this scenario. We are going to simply:
 1. Build some code from a Github repository into a container
 2. Deploy the container to OpenShift and visit the web page. 
 3. Scale the container to make a JBoss EAP cluster
 4. Make a code change in Github, rebuild the container, deploy it, and see the change 

This scenario is intended as a basic introduction for Java developers to getting their own code up and running. 
There will be other scenarios produced to show off more advanced capabilties.

### The Environment

During this training course you will be using a hosted OpenShift environment that is created just for you.  This environment is not shared with other users of the system.  Because each user taking this training has their own environment, we had to make some concessions to ensure the overall platform is stable and used only for this training.  For that reason, your environment will only be active for a one hour period.  Keep this in mind before embarking on getting through the content.  Each time you start this training or reload the web page, a new environment will be created on the fly.
 
The OpenShift environment that has been created for you is running the latest version of our open source project called OpenShift Origin.  This deployment is a self contained environment that provides everything you need to be successful in learning the platform.  This includes such things as the command line, web console, and public URLs.

With that being said, grab your favorite choice of beverage and let's do this!
