Now that we know the Thoth's provenance check adeptly caught the error, let's try running it on a fixed version of the repo - [log-thoth-provenance](https://github.com/thoth-station/s2i-example/blob/log-thoth-provenance)
If you have a look at the [Pipfile.lock](https://github.com/thoth-station/s2i-example/blob/log-thoth-provenance/Pipfile.lock), we have fixed the corrupt hash here. 
We have `THOTH_PROVENANCE_CHECK` turned on, let's try deploying this version. 

You can deploy the fixed version using - 

``oc process -f https://raw.githubusercontent.com/thoth-station/s2i-example/log-thoth-provenance/openshift.yaml | oc apply -f -``{{execute}}


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
![provenance pass](https://raw.githubusercontent.com/saisankargochhayat/katacoda-scenarios/master/thoth-provenance/assets/provenance_pass.png)

Provenance check passed! \o/

You can check the logs from the deployed app using - 

``oc logs -f dc/s2i-example-log``{{execute}}