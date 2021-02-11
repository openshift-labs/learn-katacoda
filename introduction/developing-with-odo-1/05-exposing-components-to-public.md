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
Validation
 ✓  Checking component [34ms]

Configuration changes
 ✓  Retrieving component data [27ms]
 ✓  Applying configuration [25ms]

Applying URL changes
 ✓  URL frontend: http://frontend-app-myproject.2886795278-80-frugo03.environments.katacoda.com created

Pushing to component frontend of type local
 ✓  Checking file changes for pushing [832029ns]
 ✓  No file changes detected, skipping build. Use the '-f' flag to force the build.
```

Visit the URL in your browser to view the application once the `odo push` command finishes.
