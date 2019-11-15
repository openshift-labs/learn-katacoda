In this course you learnt about deploying an application from source code using a Source-to-Image (S2I) builder. You first deployed the application from the web console, following that up with using the command line. You also learnt about using binary input source builds to run builds using source code from a local directory on your own computer.

The web application you deployed was implemented using the Python programming language. OpenShift provides S2I builders for a number of different programming languages/frameworks in addition to Python. These include Java, NodeJS, Perl, PHP and Ruby.

You can find a summary of the key commands covered below. To see more information on each ``oc`` command, run it with the ``--help`` option.

``oc new-app <image:tag>~<source-code> --name <name>``: Deploy an application from source code hosted on a Git repository using the specified S2I builder image.

``oc start-build <name>``: Trigger a new build and deployment of the application where source code is taken from the hosted Git repository specified to ``oc new-app`` when the build configuration was created.

``oc start-build <name> --from-dir=.``: Trigger a new build and deployment of the application where source code is taken from the current working directory of the local machine where the ``oc`` command is being run.

``oc cancel-build <build>``: Cancel a running build.

``oc logs bc/<name> --follow``: Monitor the log output from the current build for the application.

``oc get builds``: Display a list of all builds, completed, cancelled and running.

``oc get builds --watch``: Monitor the progress of any active builds.

``oc get pods --watch``: Monitor any activity related to pods in the project. This will include pods run to handle building and deployment of an application.
