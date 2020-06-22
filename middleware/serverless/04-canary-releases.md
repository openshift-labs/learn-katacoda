At the end of this step you will be able to:
- Configure a service to use a `Canary Release` deployment pattern

> **Note:** *If you did not complete the previous Traffic Distribution section please execute both of the following commands:*

```bash
kn service create greeter --image quay.io/rhdevelopers/knative-tutorial-greeter:quarkus --namespace serverless-tutorial --revision-name greeter-v1
kn service update greeter --image quay.io/rhdevelopers/knative-tutorial-greeter:quarkus --namespace serverless-tutorial --revision-name greeter-v2 --env MESSAGE_PREFIX=GreeterV2
```{{execute}}

## Applying a Canary Release Pattern
A Canary release is more effective when looking to reduce the risk of introducing new features. Using this type of deployment model allows a more effective feature-feedback loop before rolling out the change to the entire user base.  Using this deployment approach with Serverless allows splitting the traffic between revisions in increments as small as 1%.

To see this in action, apply the following service update that will split the traffic 80% to 20% between `greeter-v1` and `greeter-v2` by executing:
```bash
kn service update greeter \
   --traffic greeter-v1=80 \
   --traffic greeter-v2=20 \
   --traffic @latest=0
```{{execute}}

In the service configuration above see the 80/20 split between v1 and v2 of the greeter service.  Also see that the current service is set to receive 0% of the traffic using the `latest` tag.

> **Note:** *The equivalent yaml for the service above can be seen by executing: `cat 04-canary-releases/greeter-canary-service.yaml`{{execute}}

As in the previous section on Applying Blue-Green Deployment Pattern deployments, the command will not create a new configuration, revision, or deployment.

To observe the new traffic distribution execute the following:

```bash
# ./assets/04-canary-releases/poll-svc-10.bash

#!/usr/bin/env bash
for run in {1..10}
do
  curl http://greeter-serverless-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com
done
```{{execute}}

80% of the responses are returned from greeter-v1 and 20% from greeter-v2. See the listing below for sample output:

```bash
Hi  greeter => '6fee83923a9f' : 1
Hi  greeter => '6fee83923a9f' : 2
Hi  greeter => '6fee83923a9f' : 3
GreeterV2  greeter => '4d1c551aac4f' : 1
Hi  greeter => '6fee83923a9f' : 4
Hi  greeter => '6fee83923a9f' : 5
Hi  greeter => '6fee83923a9f' : 6
GreeterV2  greeter => '4d1c551aac4f' : 2
Hi  greeter => '6fee83923a9f' : 7
Hi  greeter => '6fee83923a9f' : 8
```

Also notice that two pods are running, representing both greeter-v1 and greeter-v2: `oc get pods -n serverless-tutorial`{{execute}}

```bash
NAME                                     READY   STATUS    RESTARTS   AGE
greeter-v1-deployment-5dc8bd556c-42lqh   2/2     Running   0          29s
greeter-v2-deployment-1dc2dd145c-41aab   2/2     Running   0          20s
```

> **Note:** *If we waited too long to execute the preceding command we might have noticed the services scaling to zero!*
>
> **Challenge:** *As a challenge, adjust the traffic distribution percentages and observe the responses by executing the `poll-svc-10.bash` script again.*

## Delete the Service

We will need to cleanup the project for our next section by executing: `kn service delete greeter`{{execute}}

Congrats! You now are able to apply a few different deployment patterns using Serverless.  In the next section we will see how we dig a little deeper into the scaling components of Serverless.
