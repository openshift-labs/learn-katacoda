Go to the source folder of `preference` microservice.

Execute: `cd ~/projects/istio-tutorial/preference/`{{execute T1}}

Now execute `mvn package`{{execute T1}} to create the `preference.jar` file.

## Create the preference docker image.

We will now use the provided `/preference/Dockerfile`{{open}} to create a docker image.

This image will be called `example/preference`.

To build a docker image type: `docker build -t example/preference .`{{execute T1}}

You can check the image that was create by typing `docker images | grep preference`{{execute T1}}

## Injecting the sidecar proxy.

Now let's deploy the preference pod with its sidecar.

Execute: `oc apply -f <(istioctl kube-inject -f src/main/kubernetes/Deployment.yml) -n tutorial`{{execute T1}}

Also create a service: `oc create -f src/main/kubernetes/Service.yml`{{execute T1}}

To watch the creation of the pods, execute `oc get pods -w`{{execute T1}}

Once that the preference pod READY column is 2/2, you can hit `CTRL+C`. 

Try the microservice by typing `curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute T1}}

Preferences returns a value but also an error message based on the missing recommendations service

`customer => 503 preference => I/O error on GET request for "http://recommendation:8080": recommendation; nested exception is java.net.UnknownHostException: recommendation`

This concludes the deployment of `preference` microservice.
