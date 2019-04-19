Container Orchestration is a natural progression once you are comfortable with containers on a single host, though it does require a significan paradigm shift. With a single container host, applications can be managed with many traditional methodologies used in non-containerized environments. With orchestration, developers and administrators alike need to think differently, making all changes to applications through and API.

Some people question the "complexity" of orchestration, but the benefits far out weigh the paradigm shift. Today, Kubernetes is the clearn winner when it comes to container orchestration, and with it, you gain:

* Application Definitions - YAML and JSON files can be passed between developers or from developers to operators to run fully funtioning, multi-container applications
* Multiple Applications - Run many versions of the same application in different namespaces
* Multi-Node Scheduling - controllers built into Kubernete manage 10 or 10,000 container hosts with no extra complexity
* Powerful API - Developers, Cluster Admins, and Automation alike can define application state, tenancy, and with OpenShift 4, even cluster node states
* Operational Automation - The [Kubernetes Operator Framework](https://coreos.com/operators/) can be thought of as a robot systems administrator deployed side by side with applications managing mundane and complex day two tasks
* Higher Level Frameworks - Once you adopt Kubernetes orchestration, you gain access to an innovative ecosystem of tools like Istio, Knative, and the previously mentioned Operator Framework

![Containers Are Linux](../../assets/subsystems/container-internals-lab-2-0-part-1/04-simple-container-engine.png)


To demonstrate, with a single command, let's create a multi-container application with both a database and a web front end. For simplicities sake and so that technology doesn't get in the way, we will use our super simple container image from before. But, let's expand on it by running it as a simulated database as well as a simulated web server. Take a quick look at this YAML file - don't try to understand it well yet, but understand that it wires together a full application with DNS:

`curl https://raw.githubusercontent.com/fatherlinux/two-pizza-team/master/two-pizza-team-ubi.yaml`{{execute}}

If you are good with Kubernetes YAML, you may understand it, but if not, this Kubernetes defition wires together the resources to build the following application:

~~~~
User -> Web App (port 80) -> Database (port 3306)
~~~~

In reality we are just using netcat to push some text over the associated ports. The idea is to show a simple example of how powerful this is without having to learn other technology. We are able to wire this entire application together with just a little YAML. Now, create the application in Kubenretes by submitting this file to the API:

`oc create -f https://raw.githubusercontent.com/fatherlinux/two-pizza-team/master/two-pizza-team-ubi.yaml`{{execute}}


Pull some data from our newly created "web app."  Notice that we get back our /etc/redhat-release file from the database server, not the web server:

`curl $(kubectl get svc pepperoni-pizza -o yaml | grep ip | awk '{print $3}')`{{execute}}

Now, let's pull data directly from the "database."  It's the same file as we would expect, but this time coming back over port 3306:

`curl $(kubectl get svc pepperoni-pizza -o yaml | grep ip | awk '{print $3}')`{{execute}}

Hopefully, this demonstrates how powerful container orchestration is. Note that we could fire up 50 copies of this application in Kubernetes with 49 more commands. It's that easy


