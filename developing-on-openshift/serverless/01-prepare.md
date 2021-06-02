[serverless-install-script]: https://github.com/openshift-labs/learn-katacoda/blob/master/developing-on-openshift/serverless/assets/01-prepare/install-serverless.bash
[olm-docs]: https://docs.openshift.com/container-platform/latest/operators/understanding/olm/olm-understanding-olm.html
[serving-docs]: https://github.com/knative/serving-operator#the-knativeserving-custom-resource

OpenShift Serverless is an OpenShift add-on that can be installed via an operator that is available within the OpenShift OperatorHub.

Some operators are able to be installed into single namespaces within a cluster and are only able to monitor resources within that namespace.  The OpenShift Serverless operator is one that installs globally on a cluster so that it is able to monitor and manage Serverless resources for every single project and user within the cluster.

You could install the Serverless operator using the *Operators* tab within the web console, or you can use the CLI tool `oc`.  In this instance, the terminal on the side is already running through an automated CLI install.  This [script can be found here][serverless-install-script].

Since the install will take some time, let's take a moment to review the installation via the web console.

> **Note:** *These steps are for informational purposes only. **Do not** follow them in this instance as there already is an automated install running in the terminal.*

## Log in and install the operator
This section is automated, so you won't need to install the operator.  If you wanted to reproduce these results on another cluster, you'd need to authenticate as an admin to complete the following steps:

![01-login](/openshift/assets/developing-on-openshift/serverless/01-prepare/01-login.png)

Cluster administrators can install the `OpenShift Serverless` operator via *Operator Hub*

![02-operatorhub](/openshift/assets/developing-on-openshift/serverless/01-prepare/02-operatorhub.png)

> **Note:** *We can inspect the details of the `serverless-operator` packagemanifest within the CLI via `oc describe packagemanifest serverless-operator -n openshift-marketplace`.*
>
> **Tip:** *You can find more information on how to add operators on the [OpenShift OLM Documentation Page][olm-docs].*

Next, our scripts will install the Serverless Operator into the `openshift-operators` project using the `stable` update channel.

![03-serverlessoperator](/openshift/assets/developing-on-openshift/serverless/01-prepare/03-serverlessoperator.png)

Open the **Installed Operators** tab and watch the **OpenShift Serverless Operator**.  The operator is installed and ready when the `Status=Succeeded`.

![05-succeeded](/openshift/assets/developing-on-openshift/serverless/01-prepare/05-succeeded.png)

> **Note:** *We can inspect the additional api resouces that the serverless operator added to the cluster via the CLI command `oc api-resources | egrep 'Knative|KIND'`*.

Next, we need to use these new resources provided by the serverless operator to install KnativeServing.

## Install KnativeServing
As per the [Knative Serving Operator documentation][serving-docs] you must create a `KnativeServing` object to install Knative Serving using the OpenShift Serverless Operator.

> **Note:** *Remember, these steps are for informational purposes only. **Do not** follow them in this instance as there already is an automated install running in the terminal.*

First we create the `knative-serving` project.

![06-kservingproject](/openshift/assets/developing-on-openshift/serverless/01-prepare/06-kservingproject.png)

Within the `knative-serving` project open the **Installed Operators** tab and the **OpenShift Serverless Operator**.  Then create an instance of **Knative Serving**.

![07-kservinginstance](/openshift/assets/developing-on-openshift/serverless/01-prepare/07-kservinginstance.png)

![08-kservinginstance](/openshift/assets/developing-on-openshift/serverless/01-prepare/08-kservinginstance.png)

Open the Knative Serving instance.  It is deployed when the **Condition** `Ready=True`.

![09-kservingready](/openshift/assets/developing-on-openshift/serverless/01-prepare/09-kservingready.png)

OpenShift Serverless should now be installed!

## Login as a Developer and Create a Project
Before beginning we should change to the non-privileged user `developer` and create a new `project` for the tutorial.

> **Note:** *Remember, these steps are for informational purposes only. **Do not** follow them in this instance as there already is an automated install running in the terminal.*

To change to the non-privileged user in our environment we login as username: `developer`, password: `developer`

Next create a new project by executing: `oc new-project serverless-tutorial`

There we go! You are all set to kickstart your serverless journey with **OpenShift Serverless**. 

Please check for the terminal output of `Serverless Tutorial Ready!` before continuing.  Once ready, click `continue` to go to the next module on how to deploy your first severless service.
