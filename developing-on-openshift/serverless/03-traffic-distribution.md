At the end of this step you will be able to:
- Provide a custom `name` to the deployment
- Configure a service to use a `blue-green` deployment pattern

Serverless services always route traffic to the **latest** revision of the deployment. In this section we will learn a few different ways to split the traffic between revisions in our service.

## Revision Names
By default, Serverless generates random revision names for the service that is based on using the Serverless service’s `metadata.name` as a prefix.

The following service deployment uses the same greeter service as the last section in the tutorial except it is configured with an arbitrary revision name.

Let's deploy the greeter service again, but this time set its **revision name** to `greeter-v1` by executing:
```bash
kn service create greeter \
   --image quay.io/rhdevelopers/knative-tutorial-greeter:quarkus \
   --namespace serverless-tutorial \
   --revision-name greeter-v1
```{{execute}} 

> **Note:** *The equivalent yaml for the service above can be seen by executing: `cat 03-traffic-distribution/greeter-v1-service.yaml`{{execute}}*.

Next, we are going to update the greeter service to add a message prefix environment variable and change the revision name to `greeter-v2`.  Do so by executing:
```bash
kn service update greeter \
   --image quay.io/rhdevelopers/knative-tutorial-greeter:quarkus \
   --namespace serverless-tutorial \
   --revision-name greeter-v2 \
   --env MESSAGE_PREFIX=GreeterV2
```{{execute}} 

> **Note:** *The equivalent yaml for the service above can be seen by executing: `cat 03-traffic-distribution/greeter-v2-service.yaml`{{execute}}*.

See that the two greeter services have deployed successfully by executing `kn revision list`{{execute}}

The last command should output two revisions, `greeter-v1` and `greeter-v2`:

```bash
NAME         SERVICE   TRAFFIC   TAGS   GENERATION   AGE    CONDITIONS   READY   REASON
greeter-v2   greeter   100%             2            4m5s   3 OK / 4     True    
greeter-v1   greeter                    1            14m    3 OK / 4     True 
```

> **Note:** *It is important to notice that by default the latest revision will replace the previous by receiving 100% of the traffic.*

## Blue-Green Deployment Patterns
Serverless offers a simple way of switching 100% of the traffic from one Serverless service revision (blue) to another newly rolled out revision (green).  We can rollback to a previous revision if any new revision (e.g. green) has any unexpected behaviors.

With the deployment of `greeter-v2` serverless automatically started to direct 100% of the traffic to `greeter-v2`. Now let us assume that we need to roll back `greeter-v2` to `greeter-v1` for some reason.

Update the greeter service by executing:
```bash
kn service update greeter \
   --traffic greeter-v1=100 \
   --tag greeter-v1=current \
   --tag greeter-v2=prev \
   --tag @latest=latest
```{{execute}}

The above service definition creates three sub-routes(named after traffic tags) to the existing `greeter` route.
- **current**: The revision will receive 100% of the traffic distribution
- **prev**: The previously active revision, which will now receive no traffic
- **latest**: The route pointing to the latest service deployment, here we change the default configuration to receive no traffic.

> **Note:** *Be sure to notice the special tag: `latest` in our configuration above.  In the configuration we defined 100% of the traffic be handled by `greeter-v1`.*
>
> *Using the latest tag allows changing the default behavior of services to route 100% of the traffic to the latest revision.*

We can validate the service traffic tags by executing: `kn route describe greeter`{{execute}}

The output should be similar to:

```bash
Name:       greeter
Namespace:  serverless-tutorial
Age:        1m
URL:        http://greeter-serverless-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com
Service:    greeter

Traffic Targets:  
    0%  @latest (greeter-v2) #latest
        URL:  http://latest-greeter-serverless-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com
  100%  greeter-v1 #current
        URL:  http://current-greeter-serverless-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com
    0%  greeter-v2 #prev
        URL:  http://prev-greeter-serverless-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com

Conditions:  
  OK TYPE                  AGE REASON
  ++ Ready                 23s 
  ++ AllTrafficAssigned     1m 
  ++ IngressReady          23s 
```

> **Note:** *The equivalent yaml for the service above can be seen by executing: `cat 03-traffic-distribution/service-pinned.yaml`{{execute}}*.

The configuration change we issued above does not create any new `configuration`, `revision`, or `deployment` as there was no application update (e.g. image tag, env var, etc).  When calling the service without the sub-route, Serverless scales up the `greeter-v1`, as our configuration specifies and the service responds with the text `Hi greeter ⇒ '9861675f8845' : 1`.

We can check that `greeter-v1` is receiving 100% of the traffic now to our main route by executing: `curl http://greeter-serverless-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute}}

> **Challenge:** *As a test, route all of the traffic back to `greeter-v2` (green).*

Congrats! You now are able to apply a a `blue-green` deployment pattern using Serverless.  In the next section we will look at `canary release` deployments.
