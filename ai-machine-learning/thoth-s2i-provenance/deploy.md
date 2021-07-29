Now that you are familiar with the configurations our s2i image offers, let's try deploying our sample app using Thoth's S2I build process. 

Assuming you have followed the steps from before are logged in as an admin into `myproject` in the OpenShift cluster lets deploy - 

As the cluster is ready now, let's try deploying the application using Thoth S2I build process - 

``oc process -f https://raw.githubusercontent.com/thoth-station/s2i-example/log-thoth-broken/openshift.yaml | oc apply -f -``{{execute}}


Now that you have scheduled it in the katacoda terminal on the right, you should see this - 
```
buildconfig.build.openshift.io/s2i-example-log created
deploymentconfig.apps.openshift.io/s2i-example-log created
imagestream.image.openshift.io/s2i-example-log created
imagestream.image.openshift.io/s2i-thoth-ubi8-py38 created
```

### Let's go to Openshift UI and checkout our build process - 

Make sure you have selected `myproject` on the project selector. 
If you go to Builds in the OpenShift UI in the other tab, under `Builds`, you would see `s2i-example-log` and under logs you could inspect the build process. 
You would see `thamos provenance-check` being run your stack. 

You can also check the logs from the terminal. Lets check the logs - 

``oc logs bc/s2i-example-log -f``{{execute}}

You should keep a eye for these things in the log - 
 - Thoth's configuration file after hardware and software discovery (that's the .thoth.yaml being expanded from the template.)
 - Asking Thoth for provenance check... (That is where Thamos interacts with Thoth API)

If you scroll to the end of it, you should see something similar to this - 
![provenance fail](https://raw.githubusercontent.com/saisankargochhayat/katacoda-scenarios/master/thoth-provenance/assets/provenance_fail.png)

We can see `python-json-logger` has an `INVALID-ARTIFACT-HASH`. Let's figure out why this happened - 
If you take a look at the [Pipfile.lock](https://github.com/thoth-station/s2i-example/blob/log-thoth-broken/Pipfile.lock#L29) 
Right there at line 29, we have the corrupt SHA that was caught during the provenance check and we prevented a potentially unsafe package from being uninstalled. 

Now let's pull down the app you deployed and deploy a version that is not broken - 

``oc delete all --selector 'app=s2i-example-log'``{{execute}}