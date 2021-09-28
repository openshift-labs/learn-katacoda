Now that you are familiar with the configurations our s2i image offers, let's try deploying our sample app using Thoth's S2I build process. 

Assuming you have followed the steps from before and are logged in as an admin into `myproject` in the openshift cluster lets deploy - 

You can try deploying our version using - 

``oc process -f https://raw.githubusercontent.com/thoth-station/s2i-example/log-thoth/openshift.yaml | oc apply -f -``{{execute}}




Now that you have scheduled it in the katacoda terminal on the right, you should see this - 
```
buildconfig.build.openshift.io/s2i-example-log created
deploymentconfig.apps.openshift.io/s2i-example-log created
imagestream.image.openshift.io/s2i-example-log created
imagestream.image.openshift.io/s2i-thoth-ubi8-py38 created
```

### Let's go to Openshift UI and checkout our build process - 

Make sure you have selected `myproject` on the project selector. 
If you go to Builds in the Openshift UI in the other tab, under `Builds`, you would see `s2i-example-log` and under logs you could inspect the build process. 
You would see `thamos advise` being run on your stack and if there is a suggestion. 
Incase the analysis fails, we resort to the existing Pipfile.lock to prevent the build from failing. 

Now lets check the logs - 

``oc logs bc/s2i-example-log -f``{{execute}}

You should keep a eye for these things in the log - 
 - Thoth's configuration file after hardware and software discovery (that's the .thoth.yaml being expanded from the template.)
 - Asking Thoth for advise... (That is where thamos interacts with Thoth API)

Now if you check the UI, your app should be running under `Workloads -> Pods`.

Once the application is deployed, you can check the logs from the deployed app using - 

``oc logs -f bc/s2i-example-log``{{execute}}

After Thoth finishes processing your stack you should see something similar to this in your report - 
![thoth advise pass](https://raw.githubusercontent.com/saisankargochhayat/katacoda-scenarios/master/hello-world/assets/thamos_advise_pass.png)

If you want to remove the app from the cluster - 

``oc delete all --selector 'app=s2i-example-log'``{{execute}}