Now let's take a look at the OpenShift daemons which are runnning on the master:

``mega-proc.sh openshift``{{execute}}''

Pay particular attention the the following daemons. The OpenShift/Kubernetes code is very modular. OpenShift compiles all of the functionality into a single binary and determines which role the daemon will play with startup parameters. Depending on which installation method (single node, clustered, registry server only, manual) is chosen the OpenShift binaries can be started in different ways.

- **openshift start master api**: This process handles all API calls with REST, kubectl, or oc commands.
- **/usr/bin/openshift start node**: This process plays the role of the Kubelet and communicates with dockerd (which then communicates with the kernel) to create containers.
- **/usr/bin/openshift start master controllers**: This daemon embeds the core control loops shipped with Kubernetes. A controller is a control loop that watches the shared state of the cluster through the apiserver and makes changes attempting to move the current state towards the desired state. Examples of controllers that ship with Kubernetes today are the replication controller, endpoints controller, namespace controller, and serviceaccounts controller.
