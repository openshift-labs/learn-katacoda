With OpenShift having an understanding of how the application is deployed, it is capable of running multiple instances of the containers. Scaling is based on the number of desired replicas of the deployment. Under the covers, OpenShift will start or stop the pods required to match the state you want.  

## Task

1) Visit the overview page for the project at  https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/webapp/overview

2) For each project, use the **up** and **down** arrows to scale the number of running pods. With the route in place, OpenShift will automatically load balance incoming requests across all the available Pods.

3) The pods will be listed at  https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/webapp/browse/pods

4) When accessing the route, you will be load balanced between the different containers. `curl docker-http-server-webapp.router.default.svc.cluster.local`{{execute}}

5) When scaling down, the Pods will be removed from the load balancer and then stopped.

The OpenShift UI allows you to administrate and manage your entire application deployments via the User Interface. This can be combined with the CLI, enabling you to solve the problem using your personal preference.
