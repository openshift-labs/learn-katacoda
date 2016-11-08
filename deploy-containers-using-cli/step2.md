Using the CLI, it's possible to view the status of applications and the individual Docker containers running on the cluster.

Application containers are deployed as Pods. A Pod is a group of containers that all share a unique IP address and shared storage allowing them to act as a logical host. This group of containers should only include tightly coupled dependencies as they're managed and scaled as a single unit.

Our previous command to create the new application deployed the HTTP server as a Pod containing one container.

## Task

Using the CLI, view the status of the deployment and verify the application starts correctly.

The command `oc get dc`{{execute}} includes details on how many instances are currently running along with how many are required. The desired total allows you to identify potential issues or resource constraints blocking future deployments.

To view the status of a particular application's deployment, use the command `oc deploy ws-app1`{{execute}}. The output includes the versions currently running, useful when applying a rolling update.

To view the underlying Pods use `oc get pods`{{execute}}. The status of _ContainerCreating_ indicates it's being setup and Docker Images downloaded before it enters a running state.

Each Pod has been assigned a unique name containing the application, revision and a random id. Pod names are be used to obtain additional information, such as the log files.

The following command obtains the name of the Pod for the application _ws-app1_. The name is then used to query and retrieve the logs for all the containers running.

`pod=$(oc get pods --selector="app=ws-app1" --output=jsonpath={.items..metadata.name})
oc logs $pod`{{execute}}

The Pod will need to be in a running state for the logs to be obtained. The next step will make this deployment available to external requests.
