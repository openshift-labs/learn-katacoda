[serverless-install-script]: https://github.com/btannous/learn-katacoda/blob/serverless/middleware/serverless/assets/01-prepare/install-serverless.bash
# TODO: Update this link ^
[olm-docs]: https://docs.openshift.com/container-platform/4.4/operators/olm-adding-operators-to-cluster.html
[serving-docs]: https://github.com/knative/serving-operator#the-knativeserving-custom-resource

OpenShift Serverless is an OpenShift add-on that can be installed via an operator that is available within the OpenShift OperatorHub.

Some operators are able to be installed into single namespaces within a cluster and are only able to monitor resources within that namespace.  The OpenShift Serverless operator is one that installs globally on a cluster so that it is able to monitor and manage Serverless resources for every single project and user within the cluster.

You could install the Serverless operator using the *Operators* tab within the web console, or you can use the CLI tool `oc`.  In this instance, the terminal on the side is already running through an automated CLI install.  This [script can be found here][serverless-install-script].

Since the install will take some time, let's take a moment to review the installation via the web console.

> **Note:** *These steps are for informational purposes only. **Do not** follow them in this instance as there already is an automated install running in the terminal.*

## Log in and install the operator
To install an operator, you need to log in as an admin.

# TODO: Login image

Now logged in as an admin, open the *Operator Hub* and find and select the `OpenShift Serverless` operator.

# TODO: OperatorHub Search + Serverless info page image

> **Note:** *We can inspect the details of the `serverless-operator` packagemanifest within the CLI via `oc describe packagemanifest serverless-operator -n openshift-marketplace`.*
>
> **Tip:** *You can find more information on how to add operators on the [OpenShift OLM Documentation Page][olm-docs].*

Next, install the Serverless Operator into the `openshift-operators` project.  We choose the update channel of `4.4` to match the OpenShift Container Platform version that we are using.

# TODO: Install config image
![installplan](/openshift/assets/middleware/serverless/01-prepare/installplan.png "Approve Install Plan")
# TODO: ^

Open the **Installed Operators** tab and the **OpenShift Serverless Operator**.  The operator is installed and ready when the `Status=Succeeded`.

# TODO: Status image

> **Note:** *We can inspect the additional api resouces that the serverless operator added to the cluster via the CLI command `oc api-resources | egrep 'Knative|KIND'`*.

Next, we need to use these new resources provided by the serverless operator to install KnativeServing.

## Install KnativeServing
As per the [Knative Serving Operator documentation][serving-docs] you must create a `KnativeServing` object to install Knative Serving using the OpenShift Serverless Operator.

> **Note:** *Rembmer, these steps are for informational purposes only. **Do not** follow them in this instance as there already is an automated install running in the terminal.*

First we create the `knative-serving` project.

# TODO: Image of project create.

Within the `knative-serving` project open the **Installed Operators** tab and the **OpenShift Serverless Operator**.  Then create an instance of **Knative Serving**.

# TODO: Image of knative serving instance.

the Knative Serving instance is deployed when the **Condition** `Ready=True`.

# TODO: CR Ready =true

OpenShift Serverless should now be installed!

## Login as a Developer and Create a Project
Before beginning we should change to the non-privileged user `developer` and create a new `project` for the tutorial.

> **Note:** *Rembmer, these steps are for informational purposes only. **Do not** follow them in this instance as there already is an automated install running in the terminal.*

To change to the non-privileged user in our environment we login as username: `developer`, password: `developer`

Next create a new project by executing: `oc new-project serverless-tutorial`

There we go! You are all set to kickstart your serverless journey with **OpenShift Serverless**. 

Please check for the terminal output of `Serverless Tutorial Ready!` before continuing.  Once ready, click `continue` to go to the next module on how to deploy your first severless service.
