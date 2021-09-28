Now that we have our app running on OpenShift, let's see what we can do.

## Restrict resources

Let's make _sure_ our Quarkus app doesn't go beyond a reasonable amount of memory for each instance by setting _resource constraints_ on it. We'll go with 50 MB of memory as an upper limit (which is pretty thin, compared to your average Java app!). This will let us scale up quite a bit. Click here to set this limit:

`oc set resources dc/getting-started --limits=memory=50Mi`{{execute T1}}

## Scale the app

With that set, let's see how fast our app can scale up to 10 instances:

`oc scale --replicas=10 dc/getting-started`{{execute T1}}

Back in the  [OpenShift Developer Toplogy](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/topology/ns/quarkus) you'll see the app scaling dynamically up to 10 pods:

![Scaling](/openshift/assets/middleware/quarkus/scaling.png)

This should only take a few seconds to complete the scaling. Now that we have 10 pods running, let's hit it with some load:

`for i in {1..50} ; do curl http://getting-started-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/hello/greeting/quarkus-on-openshift ; sleep .05 ; done`{{execute T1}}

You can see the 10 instances of our Quarkus app being load-balanced and responding evenly:

```console
hello quarkus-on-openshift from getting-started-2-tfvn4
hello quarkus-on-openshift from getting-started-2-8f45l
hello quarkus-on-openshift from getting-started-2-xgg97
hello quarkus-on-openshift from getting-started-2-8xw8b
...
```

> For more fun with load balancing and apps, checkout the [Red Hat Developer Istio Tutorial](https://bit.ly/istio-tutorial) and learn how to control this with much greater precision and flexibility!

10 not enough? Let's try 50:

`oc scale --replicas=50 dc/getting-started`{{execute T1}}

Back in the [Overview in the OpenShift Console](https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/quarkus/overview) you'll see the app scaling dynamically up to 50 pods:

![Scaling to 50](/openshift/assets/middleware/quarkus/50pods.png)

Once they are all up and running, try the same load again:

`for i in {1..50} ; do curl http://getting-started-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/hello/greeting/quarkus-on-openshift ; sleep .05 ; done`{{execute T1}}

And witness all 50 pods responding evenly to requests. Try doing that with your average Java app running in a container! This tutorial uses a single node OpenShift cluster, but in practice you'll have many more nodes, and can scale to hundreds or thousands of replicas if and when load goes way up.

> 50 still not enough? Are you feeling lucky? Try **100**: `oc scale --replicas=100 dc/getting-started`{{execute T1}} and watch the magic on the [OpenShift Console](https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/quarkus/overview). It may take a bit of time for all 100 to spin up given this limited resource environment, but they will eventually!

# Open the solution in an IDE in the Cloud!
Want to continue exploring this solution on your own in the cloud? You can use the free [Red Hat CodeReady Workspaces](https://developers.redhat.com/products/codeready-workspaces/overview) IDE running on the free [Red Hat Developer Sandbox](http://red.ht/dev-sandbox). [Click here](https://workspaces.openshift.com) to login or to register if you are a new user. This free service expires after 30 days, but you can always enable a new free 30-day subscription.

Once logged in, [click here](https://workspaces.openshift.com/f?url=https://raw.githubusercontent.com/openshift-katacoda/rhoar-getting-started/solution/quarkus/getting-started/devfile.yaml) to open the solution for this project in the cloud IDE. While loading, if it asks you to update or install any plugins, you can say no.

# Fork the source code to your own GitHub!
Want to experiment more with the solution code you just worked with? If so, you can fork the repository containing the solution to your own GitHub repository by clicking on the following command to execute it:

`/root/projects/forkrepo.sh`{{execute T1}}
- Make sure to follow the prompts. An error saying `Failed opening a web browser at https://github.com/login/device exit status 127` is expected.
- [Click here](https://github.com/login/device) to open a new browser tab to GitHub and paste in the code you were presented with and you copied.
- Once done with the GitHub authorization in the browser, close the browser tab and return to the console and press `Enter` to complete the authentication process.
- If asked to clone the fork, press `n` and then `Enter`.
- If asked to confirm logout, press `y` and the `Enter`.

   > **NOTE:** This process uses the [GitHub CLI](https://cli.github.com) to authenticate with GitHub. The learn.openshift.com site is not requesting nor will have access to your GitHub credentials.

After completing these steps the `rhoar-getting-started` repo will be forked in your own GitHub account. On the `solution` branch in the repo, the `getting-started` project inside the `quarkus` folder contains the completed solution for this scenario.

## Congratulations

In this scenario you got a glimpse of the power of Quarkus apps, both traditional JVM-based as well as native builds. There is much more to Quarkus than fast startup times and low resource usage, so keep on exploring additional scenarios to learn more, and be sure to visit [quarkus.io](https://quarkus.io) to learn even more about the architecture and capabilities of this exciting new framework for Java developers.
