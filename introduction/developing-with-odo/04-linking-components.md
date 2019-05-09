With both components of our application running on the cluster, we need to connect them so they can communicate. OpenShift provides mechanisms to publish communication bindings from a program to its clients. This is referred to as linking.

To link the current `frontend` component to the `backend` you can run:

`odo link backend --component frontend --port 8080`{{execute}}

This will inject configuration information into the frontend about the backend and then restart the frontend.
