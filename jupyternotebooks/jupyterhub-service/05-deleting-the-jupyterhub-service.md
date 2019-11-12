When you are done with the JupyterHub service you can delete it from the command line.

To validate that you are deleting the correct resources, first run:

``oc get all,configmap,pvc,serviceaccount,rolebinding --selector app=jupyterhub -o name``{{execute}}

This uses a label selector to reference only the resources for this deployment.

When happy that you will be deleting the correct resources, run:

``oc delete all,configmap,pvc,serviceaccount,rolebinding --selector app=jupyterhub``{{execute}}
