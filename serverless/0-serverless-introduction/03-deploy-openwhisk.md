# Setup Apache OpenWhisk on OpenShift

Having prepared the OpenShift environment to deploy Apache OpenWhisk in the previous step of this scenario, you will now
do the deployment.

**1. Deploy OpenWhisk**

Make sure we are in `faas` project:

``oc project -q``{{execute}}

Deploy OpenWhisk on to OpenShift:

``oc process -f https://git.io/vpnUR | oc create -f -``{{execute}}

**2. Wait for OpenWhisk Platform to Achieve Stable State**

Apache OpenWhisk is comprised of many components that must startup and then sync-up with each other and this process can
take several minutes to achieve stable state.  The following command will wait until the component pods are running:

``while $(oc get pods -n faas controller-0 | grep 0/1 > /dev/null); do sleep 1; done``{{execute}}

**IMPORTANT**

Please proceed to next step if and only if the **controller** is ready.  You can check this with:

``while [ -z "`oc logs controller-0 -n faas 2>&1 | grep "invoker status changed"`" ]; do sleep 1; done``{{execute}}

**3. Edit OpenWhisk Ngnix Route TLS**

By default the Apache OpenWhisk nginx route is configured to do "Redirect" for edge termination.  However, in Katacoda
all the requests are secured hence we need to modify nginx route **openwhisk** insecureEdgeTerminationPolicy to "Allow"

``oc patch route openwhisk --namespace faas -p '{"spec":{"tls": {"insecureEdgeTerminationPolicy": "Allow"}}}'``{{execute}}

**4. Configure OpenWhisk CLI**

Get the default authentication and authorization credentials:

``AUTH_SECRET=$(oc get secret whisk.auth -o yaml | grep "system:" | awk '{print $2}' | base64 --decode)``{{execute}}

Set OpenWhisk CLI with authentication and API Host:

``wsk property set --auth $AUTH_SECRET --apihost $(oc get route/openwhisk --template="{{.spec.host}}")``{{execute}}

You can verify the settings via the command:

``wsk -i property get``{{execute}}

**5. Verify OpenWhisk CLI setup**

``wsk -i action list``{{execute}}

Successful execution of the above command should display output like below:

![OpenWhisk Default Catalog](/openshift/assets/serverless/0-serverless-introduction/ow_catalog_actions.png)

## Congratulations

You have now deployed [Apache OpenWhisk](https://openwhisk.apache.org/) to the [OpenShift Container Platform](https://openshift.com]). 
