With both components of our application running on the cluster, we need to connect them so they can communicate. OpenShift provides mechanisms to publish communication bindings from a program to its clients. This is referred to as linking.

To link the current `frontend` component to the `backend`, you can run:

`odo link backend --component frontend --port 8080`{{execute}}

This will inject configuration information into the `frontend` about the `backend` and then restart the `frontend` upon running an `odo push`.

The following output will be displayed to confirm the linking information has been added to the configuration of the `frontend` and `backend` components:

```
 ✓  Component backend has been successfully linked from the component frontend
```

Before we push the linking updates, let's make some other changes in `frontend`'s configuration.
