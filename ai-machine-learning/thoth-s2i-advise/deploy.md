Now that you are familiar with the configurations our s2i image offers, let's try deploying our sample app using Thoth's S2I build process. 

Assuming you have followed the steps from before are logged in as an admin into `myproject` in the openshift cluster lets deploy - 

``oc process -f https://raw.githubusercontent.com/<your-github-username>/s2i-example/log-thoth/openshift.yaml | oc apply -f -``

If you haven't forked the repo and made any changes, you can try deploy our version using - 

``oc process -f https://raw.githubusercontent.com/thoth-station/s2i-example/log-thoth/openshift.yaml | oc apply -f -``{{copy}}


Now that you have scheduled it in the katacoda terminal on the right, you should see this - 
```
buildconfig.build.openshift.io/s2i-example-log created
deploymentconfig.apps.openshift.io/s2i-example-log created
imagestream.image.openshift.io/s2i-example-log created
imagestream.image.openshift.io/s2i-thoth-ubi8-py36 created
```

### Let's go to Openshift UI and checkout our build process - 

Make sure you have selected `myproject` on the project selector. 
If you go to Builds in the Openshift UI in the other tab, under `Builds`, you would see `s2i-example-log-` and under logs you could inspect the build process. 
You would see `thamos advise` being run your stack and if there is a suggestion. 
Incase the analysis fails, we resort to the existing Piplock for to prevent the build from failing. 

Your app should be running under `Workloads -> Pods`.

If you want to pull down the remove app you deployed - 

``oc delete all --selector 'app=s2i-example-log'``{{copy}}