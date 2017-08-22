Inside the project, where is this case it should be an empty project, a prominent _Add to Project_ button will be displayed in the center of the page.

![Adding to Empty Project](../../assets/intro-openshift/fis-deploy-app/02-add-to-project-empty.png)

Its now time to build and deploy our People Service API onto OpenShift. To do this we will be using OpenShifts Source 2 Image capabilities, commonly referred to as S2I. The Source-to-Image (S2I) tool injects application source code into a container image and the final product is a new and ready-to-run container image that incorporates the builder image and built source code. You can find more details regarding S2I at the finish of this scenario. 

To get started with S2I, we will use a pre-defined template for our People Service API which contains the details for the APIs build, deployment, and services configurations. The template also references the source repositories which contain the Fuse API application. For reference the template may be located [here](https://raw.githubusercontent.com/jbossdemocentral/katacoda-fuse-getting-started/master/src/main/openshift/fgstemplate.yml "People Service Template").

Lets head on back over to the terminal, by clicking on the terminal tab at the top. The first step in building and deploying our API is to add the template to OpenShift by executing the following command: SINCE THEY ARE NOT FILLING IN ANY PARAMETERS YOU COULD JUST DO A OC NEW APP AGAINST THE TEMPLATE AND IT WOULD WORK. HAVING THE TEMPLATE HERE MAKES IT A BIT CONFUSING AND MORE FOR A NEW PERSON TO TRY AND UNDERSTAND. IS THERE SOMEWHERE I CAN GO TO SEE THIS TEMPLATE - NOT SURE IT IS CRITICAL BUT IT MIGHT BE GOOD FOR FOLLOW UP LATER.

`oc new-app -f https://raw.githubusercontent.com/jbossdemocentral/katacoda-fuse-getting-started/master/src/main/openshift/fgstemplate.yml`{{execute}}

If successful, you will be prompted with the following output: 

```
 --> Deploying template "fuselab/mypeopleservice-template" for "fgstemplate.yml" to project fuselab

     mypeopleservice-template
     ---------
     Katacoda || FUSE || Getting started


     * With parameters:
        * Application Name=mypeopleservice
        * Git Repository URL=https://github.com/weimeilin79/katacoda-fuse-getting-started.git
        * CONTEXT_DIR=
        * Git Reference=master
        * Builder version=2.0
        * Application Version=1.0.0
        * Maven Arguments=package -DskipTests -Dfabric8.skip -e -B
        * Extra Maven Arguments=
        * Maven build directory=
        * Image Stream Namespace=openshift
        * Git Build Secret=mu0wpUmOlnJrlTAiSejX4b5KdYSC0kWPFQBfxEVy # generated

--> Creating resources ...
    route "mypeopleservice" created
    service "mypeopleservice" created
    imagestream "mypeopleservice" created
    buildconfig "mypeopleservice" created
    deploymentconfig "mypeopleservice" created
--> Success
    Use 'oc start-build mypeopleservice' to start a build.
    Run 'oc status' to view your app.
```

The ``oc start-build`` command tells OpenShift to start the build process which starts downloads, compiles, and utlimately packages your code deployment on OpenShift. !!!!HERE!!! Kick start and build application by running : 

`oc start-build mypeopleservice`{{execute}}

Once complete you should see output similar to: 

```build "mypeopleservice-1" started```

Using S2I
To do this we will be using the OpenShift S2I, or Source 2 Image, capabilities of OpenShift. Before we get into 


Go back to the OpenShift Web console and click the _Overview_ menu on the left.  Here  you can view the details of the application created and monitor progress as it is built and deployed.  The build will take a little while to complete. This page will refresh periodically as events in the system, such as your build, begin to occur.

![Application Overview](../../assets/intro-openshift/fis-deploy-app/02-build-in-progress.png)

Continue on to see how to monitor the build process.


