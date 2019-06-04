With both components of our application running on the cluster, we need to connect them so they can communicate. OpenShift provides mechanisms to publish communication bindings from a program to its clients. This is referred to as linking.

To link the current `frontend` component to the `backend`, you can run:

`odo link backend --component frontend --port 8080`{{execute}}

This will inject configuration information into the `frontend` about the `backend` and then restart the `frontend` component.

The following output will be displayed to confirm the linking information has been added to the `frontend` component:

```
 ✓  Component backend has been successfully linked from the component frontend
```

Now that the `frontend` component has been linked with the `backend` component, let's make `frontend` publicly accessible.
