Using the UI, it is possible to view the status of applications and the individual Docker containers running on the cluster.

Application containers are deployed as Pods. A Pod is a group of containers that all share a unique IP address and shared storage allowing them to act as a logical host. This group of containers should only include tightly coupled dependencies as they are managed and scaled as a single unit.

Our previous command to create the new application deployed the HTTP server as a Pod containing one container.

## Task

Using the UI, view the status of the deployment and verify the application starts correctly.

The page https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/webapp/overview highlights the running applications for a particular project, the version and how many pods are currently running.

To view the underlying Pods, visit https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/webapp/browse/pods.

Each Pod has been assigned a unique name containing the application, revision and a random id. Pod names are be used to obtain additional information, such as the log files.

To view the logs, click the Pod name. This will go into the details section of the individual Pod. You can view the logs by clicking on the **Logs** tab.
