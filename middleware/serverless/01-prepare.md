OpenShift Serverless are an OpenShift add-on that can be install via an operator that is available within the OpenShift OperatorHub.

Some operators are able to be installed into single namespaces within a cluster and are only able to monitor resources within that namespace.  The OpenShift Serverless operator is one that installs globally on a cluster so that it is able to monitor and manage Serverless resources for every single project and user within the cluster.

You could install the Serverless operator using the *Operators* tab within the web console, or you can use the CLI tool `oc`.  In this instance, we will use the latter.

# Login and install the operator
To install an operator, you need to log in as an admin.  You can do so by running:

`oc login -u admin -u admin`{{execute}}

Now that you have logged in, you should be able to see the packages available to you to install from the OperatorHub.  Let's take a look at the *serverless-operator* one.

`oc describe packagemanifest serverless-operator -n openshift-marketplace`{{execute}}

From that package manifest, we can see all of the information that you would need to create a Subscription to the Serverless Operator

```yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: serverless-operator
  namespace: openshift-operators
spec:
  channel: techpreview
  installPlanApproval: Manual
  name: serverless-operator
  source: redhat-operators
  sourceNamespace: openshift-marketplace
  startingCSV: serverless-operator.v1.4.1
```

> **Note:** *The installPlanApproval and startingCSV for our particular environment only supports a version of 1.4.1 at the highest, hence the differing versions from the packagemanifest spec in the terminal.*

The channel, name, starting CSV, source, and source namespace are all described in the packagemanifest you just described.

> **Tip:** *You can find more information on how to add operators on the [OpenShift Documentation Page](https://docs.openshift.com/container-platform/latest/operators/olm-adding-operators-to-cluster.html).*

For now, all you need to do is apply the associated YAML file to subscribe to the OpenShift Serverless Operator.

`oc apply -f ./01-prepare/operator-subscription.yaml`{{execute}}

# Approve and Verify the Operator Installation
The `installPlanApproval: Manual` in our Subscription requires the admin to approve the *installplan* in order for it to begin.  Normally, it might be easiest to see this from the OpenShift Web Console and approve the changes as shown in the picture below.

![installplan](.assets/01-prepare/installplan.png "Approve Install Plan")

In this tutorial we will find the installplan and approve it using the CLI:

```bash
#!/usr/bin/env bash
# Find me in `./assets/01-prepare/approve-csv.bash`
OPERATORS_NAMESPACE='openshift-operators'
OPERATOR='redhat-operators'

function approve_csv {
  local csv_version install_plan
  csv_version=$1

  install_plan=$(find_install_plan $csv_version)
  oc get $install_plan -n ${OPERATORS_NAMESPACE} -o yaml | sed 's/\(.*approved:\) false/\1 true/' | oc replace -f -
}

function find_install_plan {
  local csv=$1
  for plan in `oc get installplan -n ${OPERATORS_NAMESPACE} --no-headers -o name`; do
    [[ $(oc get $plan -n ${OPERATORS_NAMESPACE} -o=jsonpath='{.spec.clusterServiceVersionNames}' | grep -c $csv) -eq 1 && \
       $(oc get $plan -n ${OPERATORS_NAMESPACE} -o=jsonpath="{.status.catalogSources}" | grep -c $OPERATOR) -eq 1 ]] && echo $plan && return 0
  done
  echo ""
}

while [ -z $(find_install_plan 1.4.1) ]; do sleep 10; done
approve_csv 1.4.1
```{{execute}}

Since the Operator takes some time to install, we should watch it's and continue when done.

```bash
#!/usr/bin/env bash
# Find me in `.assets/01-prepare/watch-opeator-phase.bash`
phase=""

function check_for_operator_install {
  phase=`oc get csv -n openshift-operators serverless-operator.v1.4.1 -o jsonpath='{.status.phase}'`
}

check_for_operator_install
while [ $phase != "Succeeded" ]; do
  sleep 10
  check_for_operator_install
done
```{{execute}}

#TODO next install knative-serving

Before beginning, check that all pods are running in `knative-serving` namespace by executing the command `oc get -n knative-serving pods`{{execute T1}}

If the install was successful you should see the following pods in `knative-serving` namespace with the *Status* of `Running`:

```shell
NAME                                READY   STATUS    RESTARTS   AGE
activator-d6478496f-qp89p           1/1     Running   0          90s
autoscaler-6ff6d5659c-4djrt         1/1     Running   0          88s
autoscaler-hpa-868c8b56b4-296rc     1/1     Running   0          89s
controller-55b4748bc5-ndv4p         1/1     Running   0          84s
networking-istio-679dfcd5d7-2pbl4   1/1     Running   0          82s
webhook-55b96d44f6-sxj7p            1/1     Running   0          84s
```

## Login to the cluster

To begin we need to first login to OpenShift using the `developer` user. Login by executing: `oc login -u developer -p developer`{{execute T1}}

There we go! You are all set to kickstart your serverless journey with **OpenShift Serverless**. Click continue to go to next module on how to deploy your first severless service.
