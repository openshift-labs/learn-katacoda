While a build is running, the _Overview_ page will display a banner. The build may take a couple of minutes to start running because OpenShift needs to download the dependent jars needed for this project.

![Build Progress Banner](../../assets/intro-openshift/fis-deploy-app/03-build-progress-banner.png)

To view the output of the build as it is running, click on _View Log_. This will bring you to the _Logs_ tab of the _Pod_ for the build which is running.

![Running Build Log](../../assets/intro-openshift/fis-deploy-app/03-running-build-log.png)

Click on _Follow_ at the right hand side to see the latest log output as it is being produced.

If the banner is not visible, you can access build logs by selecting the _Builds_ menu and then selecting _Builds_.

![Accessing Builds Menu](../../assets/intro-openshift/fis-deploy-app/03-accessing-builds-menu.png)

This will bring up a list of builds which are currently running, as well as builds which have completed. Select on the build number of the last build to bring up the details for the build.

![List of Builds Run](../../assets/intro-openshift/fis-deploy-app/03-list-of-builds-run.png)

Select on the _Logs_ tab to bring up the log output for the build.

![Build Details](../../assets/intro-openshift/fis-deploy-app/03-build-details.png)


Once the build of the application image has completed, it will be deployed. The _Overview_ page will indicate this by the banner listing the status of the build as complete. The _Deployment Config_ pane will also show the state of the deployment and indicate the number of running pods.

![Build has Completed](../../assets/intro-openshift/fis-deploy-app/03-build-has-completed.png)

After successfully building the application, access the Hawtio console by selecting the Resource menu and select Pods.

![Select Pods menu](../../assets/intro-openshift/fis-deploy-app/03-select-pods.png)

This will bring up a list of running pods, as well as builds which have completed. Select the pod running current application:

![Pods list](../../assets/intro-openshift/fis-deploy-app/03-pods-list.png)

You will be taken directly to the pod detail page, underneath, find a link name "Open Java Console" and select it

![Select Java Console](../../assets/intro-openshift/fis-deploy-app/03-select-java-console.png)

The Hawtio console display all the available Camel routes, select the "Route Diagram" to see more detail implementation:

![Select Diagram route](../../assets/intro-openshift/fis-deploy-app/03-select-diagram-route.png)

This is what it should look like: 

![Detail Camel Route](../../assets/intro-openshift/fis-deploy-app/03-detail-camel-route.png)


