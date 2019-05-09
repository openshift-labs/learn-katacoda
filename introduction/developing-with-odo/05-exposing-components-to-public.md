We have deployed our application's backend component and connected the frontend component to it. Let's create an external URL for our application so we can see it in action:

`odo url create frontend --port 8080`{{execute}}

Once the local configuration has been updated for `frontend`, the changes can be pushed:

`odo push`{{execute}}

`odo` will print the URL generated for the application. It should be located under `Successfully created URL for component: frontend` in the console output.

Visit the URL in your browser to view the application.
