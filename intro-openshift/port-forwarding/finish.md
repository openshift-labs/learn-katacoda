In this course you learnt about ``oc`` commands you would use for setting up a temporary connection between your local machine and a service running inside of OpenShift.

You can find a summary of the key commands covered below. To see more information on each ``oc`` command, run it with the ``--help`` option.

``oc rsh <pod-name>``: Start an interactive shell in the specified pod.

``oc port-forward <pod-name> <local-port>:<remote-port>``: Forward connections between your local machine and an application running in OpenShift. The remote port is the port the application running in OpenShift accepts connections. The local port is the port on your local machine you wish to make it available as, and to which any client application running on your local machine would connect to.

``oc port-forward <pod-name> :<remote-port>``: Forward connections between your local machine and an application running in OpenShift. The remote port is the port the application running in OpenShift accepts connections. As a local port to use is not specified, a random local port is used, with the port number being displayed. Any client application running on your local machine would connect to the randomly assigned port.
