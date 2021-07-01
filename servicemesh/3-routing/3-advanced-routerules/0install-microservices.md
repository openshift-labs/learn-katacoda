Before we start this scenario, we need to deploy all microservices (customer, preference, recommendation[v1:v2]).

There's a script called `install-microservices.sh` that will

- Checkout the source code from https://github.com/redhat-developer-demos/istio-tutorial
- Create recommendation:v2
- Run `mvn package` on all projects
- Create a docker image
- Deploy the microservices with the sidecar proxy

Execute this script: `./install-microservices.sh`{{execute T1}}

> The script will take between 2-5 minutes to complete. Don't worry if you see error messages.

When the scripts ends, watch the creation of the pods, execute `oc get pods -w`{{execute T1}}

Once that the microservices pods READY column are 2/2, you can hit `CTRL+C`. 

Try the microservice by typing `curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute interrupt T1}}

It should return:

`customer => preference => recommendation v{1:2} from {hostname}: 1`