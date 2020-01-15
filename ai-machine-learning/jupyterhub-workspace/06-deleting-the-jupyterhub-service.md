When you are done with the JupyterHub service you can delete it from the command line.

To validate that you are deleting the correct resources, first run:

``oc get all,configmap,pvc,serviceaccount,rolebinding --selector app=jupyterhub -o name``{{execute}}

This uses a label selector to reference only the resources for this deployment.

When happy that you will be deleting the correct resources, run:

``oc delete all,configmap,pvc,serviceaccount,rolebinding --selector app=jupyterhub``{{execute}}

This will only delete resources from the project JupyterHub is deployed to.

You will also need to delete the global ``oauthclient`` resource. Do this as a separate step so you can double check you are deleting the correct resource.

To list the ``oauthclient`` resources run:

``oc get oauthclient --selector app=jupyterhub``{{execute}}

Delete by name the one entry corresponding to the JupyterHub deployment in this project. In this case the project name was ``myproject``, so you would run:

``oc delete oauthclient/jupyterhub-myproject-users``{{execute}}

Note that this will not delete any projects which have been created for or by users. If users had not deleted the projects themselves, you as a cluster admin will need to identify them and delete them.
