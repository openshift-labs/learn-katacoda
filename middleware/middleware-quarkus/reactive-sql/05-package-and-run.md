In the previous step you added a custom bean to the app. Let's now package it up as a production app and deploy it.

### Stop the previous application

Let's stop the original application so we can package it as an executable JAR. In the terminal, press `CTRL-C` to stop the application.

## Deploy production application to OpenShift

To deploy the application "in production", we can simply re-deploy the application using the OpenShift extension, omitting the `quarkus-launch-devmode` environment variable. Click the following command to do this:

`mvn clean package -DskipTests \
-Dquarkus.kubernetes.deploy=true \
-Dquarkus.container-image.build=true \
-Dquarkus.kubernetes-client.trust-certs=true \
-Dquarkus.kubernetes.deployment-target=openshift \
-Dquarkus.openshift.route.expose=true \
-Dquarkus.openshift.annotations.\"app.openshift.io/connects-to\"=database`{{execute}}

Finally, make sure it's actually done rolling out:

`oc rollout status -w dc/reactive-sql`{{execute}}

Wait (about 30 seconds) for that command to report `replication controller "reactive-sql-3" successfully rolled out` before continuing.

> If the `oc rollout` command appears to not finish, just `CTRL-C` it and run it again.

The output should end with `BUILD SUCCESS`.

[Open up the web UI](http://reactive-sql-reactive-sql.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com). You should see the front web page load with the List of Coffees, to which you can add (or delete).

![Reactive SQL app UI](/openshift/assets/middleware/quarkus/reactive-sql-ui.png)

# Open the solution in an IDE in the Cloud!
Want to continue exploring this solution on your own in the cloud? You can use the free [Red Hat CodeReady Workspaces](https://developers.redhat.com/products/codeready-workspaces/overview) IDE running on the free [Red Hat Developer Sandbox](http://red.ht/dev-sandbox). [Click here](https://workspaces.openshift.com) to login or to register if you are a new user. This free service expires after 30 days, but you can always enable a new free 30-day subscription.

Once logged in, [click here](https://workspaces.openshift.com/f?url=https://raw.githubusercontent.com/openshift-katacoda/rhoar-getting-started/solution/quarkus/reactive-sql/devfile.yaml) to open the solution for this project in the cloud IDE. While loading, if it asks you to update or install any plugins, you can say no.

# Fork the source code to your own GitHub!
Want to experiment more with the solution code you just worked with? If so, you can fork the repository containing the solution to your own GitHub repository by clicking on the following command to execute it:

`/root/projects/forkrepo.sh`{{execute T1}}
- Make sure to follow the prompts. An error saying `Failed opening a web browser at https://github.com/login/device exit status 127` is expected.
- [Click here](https://github.com/login/device) to open a new browser tab to GitHub and paste in the code you were presented with and you copied.
- Once done with the GitHub authorization in the browser, close the browser tab and return to the console and press `Enter` to complete the authentication process.
- If asked to clone the fork, press `n` and then `Enter`.
- If asked to confirm logout, press `y` and the `Enter`.

   > **NOTE:** This process uses the [GitHub CLI](https://cli.github.com) to authenticate with GitHub. The learn.openshift.com site is not requesting nor will have access to your GitHub credentials.

After completing these steps the `rhoar-getting-started` repo will be forked in your own GitHub account. On the `solution` branch in the repo, the `reactive-sql` project inside the `quarkus` folder contains the completed solution for this scenario.
## Congratulations!

You've packaged up the app as a production app and learned a bit more about the mechanics of packaging. In this tutorial we also used JAX-RS and deployed our application to the Openshift Container platform.

To read more about Quarkus and Reactive SQL head off to [QuarkusIO](http://www.quarkus.io) for more details.
