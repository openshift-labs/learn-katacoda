When you are done with the Jupyter notebook instance you can delete it from the command line.

To validate that you are deleting the correct resources, first run:

``oc get all --selector app=custom-notebook -o name``{{execute}}

This uses a label selector to reference only the resources for this deployment.

When happy that you will be deleting the correct resources, run:

``oc delete all --selector app=custom-notebook``{{execute}}

This will only delete the Jupyter notebook instance in this case and will not delete the custom Jupyter notebook image. For the image, run:

``oc get all --selector build=custom-notebook -o name``{{execute}}

The label selector this time is `build=custom-notebook`.

When happy that you will be deleting the correct resources, run:

``oc delete all --selector build=custom-notebook``{{execute}}

The custom Jupyter notebook image has now also been deleted.
