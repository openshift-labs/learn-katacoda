We have updated `frontend` to be linked with `backend` to allow our application's components to communicate. Let's now create an external URL for our application so we can see it in action:

`odo url create frontend --port 8080`{{execute}}

Once the URL has been created in the `frontend` component's configuration, you will see the following output:

```
✓  URL created for component: frontend

To create URL on the OpenShift cluster, please run `odo push`
```

The change can now be pushed:

`odo push`{{execute}}

`odo` will print the URL generated for the application. It should be located in the middle of the output from `odo push` similar to the output below:

```
✓  Checking component
✓  Checking component version
◑  Applying component settings to component: frontend ✓  Checking URL frontend
◒  Applying component settings to component: frontend ✓  Successfully created URL for component: frontend
✓  http://frontend-app-myproject.2886795296-80-rhsummit1.environments.katacoda.com
✓  Applying component settings to component: frontend
✓  Successfully updated component with name: frontend
✓  Pushing changes to component: frontend of type local
✓  Waiting for component to start
✓  Copying files to component
✓  Building component
✓  Changes successfully pushed to component: frontend
```

Visit the URL in your browser to view the application once the `odo push` command finishes.
