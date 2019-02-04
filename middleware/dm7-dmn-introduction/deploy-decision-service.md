We will now Build and Deploy our DMN Demo project on to the Decision Manager Execution Server. This will make our DMN model available as a Decision Service, which can be integrated with any other application via its RESTful interface. This makes our Decision Model ready for consumption in, for example, a microservices architecture.

In the project's asset library view, click on the *Build & Deploy* button. This will compile the project and package it into a KJAR or Knowledge JAR. This command will also deploy the KJAR onto the Decision Server.

Open the Execution Servers via via *Menu -> Deploy -> Execution Server*. This will show the following screen:

<img src="../../assets/middleware/dm7-loan-application/dm7-execution-servers.png" width="800" />

This view shows that we have one Execution Server template named `default-kie-server`. On this server template we've deployed one KIE Container, `loan-application_1.0.0`, which is the deployment of our Loan Application Demo KJAR. There is one Decision Server connected to our Decision Central environment, `default-kie-server@172.20.0.7:8080`, which is the Decision Server POD running in our OpenShift instance (the ip-address will obviously differ per environment).

The user can perform more actions on this screen, for example starting and stopping existing KIE-Containers, deploying new KIE-Containers to existing templates (and thus deploying them to Decision Servers that are connected to the template) and upgrading existing KJARs deployed in KIE-Containers to newer versions.

Now that are KJAR is deployed onto our Decision Server runtime, we can test our rules.




A rules session (the session in which facts are inserted and against which rules are evaluated) can be both stateful and stateless.

A *Stateful Session* is a session which is kept open until it is explicitly disposed. This allows the client to keep inserting facts into the session and fire rules against for a longer period of time. This can for example be used in *Complex Event Processing* scenario's in which a session accepts a constant stream of events against which rules are evaluated.

A *Stateless Session* is a session which is immediately disposed after the facts have been inserted and the rules have been fired. It's a one-shot approach. The client does a single request into the session in the form of a set of commands, the session executes these commands (.e.g. insert fact, fire rules), returns the result and disposes the session. This is a common architecture in stateless environments, for example when the rules engine is used to implement a decision (micro) service.

In this example we want to use a *Stateless Session*. We can configure such a session in the *Project Editor* of our rules project:

1. In the project's asset library view, click on *Settings*
2. Click on *Project Settings: Project General Settings* and select *Knowledge bases and sessions*
3. Click on *Add* (in the upper-left of the editor) and enter the name `loan-kbase`{{copy}} to add a new *KIE-Base* configuration (a *KIE-Base* is the entity that defines the rule-assets and configurations used by a session)
4. Select the just created `loan-kbase` and click on *Make Default*
4. Set *Equals Behaviour* to `Equality`
5. Set *Event Processing Mode* to `Cloud`
6. In the *Knowledge Session* section click on *Add*
7. Enter the name `loan-stateless-ksession`
8. Enable the `Default`checkbox
8. Make sure that the *State* dropdown-list is set to `Stateless` and the *Clock* to `Realtime`.
9. Click on the *Save* button to save the configuration

We've now configured a *Stateless Session* named `loan-stateless-ksession` in a *KIE-Base* called `loan-kbase`.

We can now reference this session at runtime when sending requests to the rules engine.
