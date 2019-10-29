With both components of our application running on the cluster, we need to connect them so they can communicate. OpenShift provides mechanisms to publish communication bindings from a program to its clients. This is referred to as linking.

To link the current `frontend` component to the `backend`, you can run:

`odo link backend --component frontend --port 8080`{{execute}}

This will inject configuration information into the `frontend` about the `backend` and then restart the `frontend` component.

The following output will be displayed to confirm the linking information has been added to the `frontend` component:

```
✓  Component backend has been successfully linked from the component frontend

The below secret environment variables were added to the 'frontend' component:

· COMPONENT_BACKEND_PORT
· COMPONENT_BACKEND_HOST

You can now access the environment variables from within the component pod, for example:
$COMPONENT_BACKEND_HOST is now available as a variable within component frontend
```

If you head back quickly enough to the web console by clicking on the **Console** tab, you will see the `frontend` component have its dark blue ring turn light blue again. This means that the pod for `frontend` is being restarted so that it will now run with information about how to connect to the `backend` component. When the frontend component has a dark blue ring around it again, the linking is complete.

Once the linking is complete, you can click on the `frontend` component circle again and select **View Logs**. This time, instead of an error message, you will see the following confirming the `frontend` is properly communicating with the `backend` component:

```
Listening on 0.0.0.0, port 8080
Frontend available at URL_PREFIX: /
Proxying "/ws/*" to 'backend-app:8080'
```

Now that the `frontend` component has been linked with the `backend` component, let's make `frontend` publicly accessible.
