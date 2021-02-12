With both components of our application running on the cluster, we need to confifigure the frontend to connect to the backend service. 

Configure the `frontend` component to connect to the `backend` by running:

`odo config set --env COMPONENT_BACKEND_PORT=8080,COMPONENT_BACKEND_HOST=backend-app`{{execute}}

This will inject configuration information into the `frontend` about the `backend`.  Run `odo push` to distribute the configuration changes and restart the `frontend` component.

`odo push`{{execute}}

If you head back quickly enough to the web console by clicking on the **Console** tab, you will see the `frontend` component have its dark blue ring turn light blue again. This means that the pod for `frontend` is being restarted so that it will now run with information about how to connect to the `backend` component. When the frontend component has a dark blue ring around it again, the linking is complete.

Click on the `frontend` component circle and select **View Logs**. This time, instead of an error message, you will see the following confirming the `frontend` is properly communicating with the `backend` component:

```
Listening on 0.0.0.0, port 8080
Frontend available at URL_PREFIX: /
Proxying "/ws/*" to 'backend-app:8080'
```

Now that the `frontend` component has successfully connected to the `backend` component, let's add a `Route` to make the `frontend` publicly accessible.
