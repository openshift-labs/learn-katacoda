The build may take a moment to start running if the environment needs to update the S2I builder image being used due to a newer version being available.

Once the build has started, click on the _View Logs_ link shown on the _Resources_ panel which was displayed when clicking anywhere within the ring of the visualisation for the application on the topology view.

![Accessing Build Logs](../../assets/introduction/deploying-python-42/03-application-build-logs.png)

This will allow you to monitor the progress of the build as it runs. The build will have completely successfully when you see a final message of "Push successful". This indicates that the container image for the application was pushed to the OpenShift internal image registry, allowing the application to then be deployed.
