The default configuration for the JupyterHub service created allows for anonymous access and nothing is persistent.

JupyterHub is however a highly configurable system. The template and JupyterHub image provide a starting point which you can build on, to customize it for your specific requirements. This includes being able to use your own authentication provider to control who can access the service, or add persistence for authenticated user sessions.

Depending on the type of configuration required, and whether additional application services need to be created, there are a number of different methods you can use to customize the deployment.

The first of these is to provide configuration through the template parameters. To do this we will create the deployment from the command line by running:

``oc process jupyterhub-deployer --param JUPYTERHUB_CONFIG="`cat jupyterhub_config.py`" --param JUPYTERHUB_ENVVARS="`cat jupyterhub_config.sh`" | oc apply -f -``{{execute}}

This will supply configuration which configures the JupyterHub service to use OpenShift as the authentication mechanism to control who can access the service. Only users who have an existing user account in the OpenShift cluster will be able to access the service.

To monitor the deployment run:

``oc rollout status dc/jupyterhub``{{execute}}

When complete, jump back to the _Topology_ view of the web console and click on the URL short cut for the application to access it. This time when you access the JupyterHub service, you should be prompted to login with your OpenShift cluster credentials first.

For the credentials, enter:

* **Username:** ``developer``{{copy}}
* **Password:** ``developer``{{copy}}

When you have verified access, delete the JupyterHub service again:

``oc delete all,configmap,pvc,serviceaccount,rolebinding --selector app=jupyterhub``{{execute}}
