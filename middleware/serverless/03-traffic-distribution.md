At the end of this step you will be able to:
- Provide a custom `name` to the deployment
- Configure a service to use a `blue-green` deployment pattern

As you might have noticed, Serverless services always route traffic to the **latest** revision of the deployment. In this section we will learn a few different ways to split the traffic between revisions in our service.

## Revision Names
By default, Serverless generates random revision names for the service that is based on using the Serverless service’s `metadata.name` as a prefix.

The following service deployment uses the same greeter service as the last section in the tutorial except it is configured with an arbitrary revision name.

```yaml
# ./assets/03-traffic-distribution/greeter-v1-service.yaml

apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: greeter
  namespace: serverless-tutorial
spec:
  template:
    metadata:
      name: greeter-v1
    spec:
      containers:
        - image: quay.io/rhdevelopers/knative-tutorial-greeter:quarkus
          livenessProbe:
            httpGet:
              path: /healthz
          readinessProbe:
            httpGet:
              path: /healthz

```

Compare that to line 6 - line 10 of the previous deployed service.

```yaml
# ./assets/02-serving/service.yaml#L6-L10

spec:
  template:
    spec:
      containers:
      - image: quay.io/rhdevelopers/knative-tutorial-greeter:quarkus
```

> **Note:** *Notice how there is no `spec.template.metadata.name` in the original service.*

Let's deploy the Greeter v1 Service Revision by executing: `oc apply -n serverless-tutorial -f 03-traffic-distribution/greeter-v1-service.yaml`{{execute}}

Next, we are going to deploy a Greeter v2 Service Revision.  We change `metadata.name` in the following configuration as well as add a message prefix that our service will output to us.  See the changes in the following subset of configuration below:

```yaml
# ./assets/03-traffic-distribution/greeter-v2-service.yaml#L6-L15

spec:
  template:
    metadata:
      name: greeter-v2
    spec:
      containers:
      - image: quay.io/rhdevelopers/knative-tutorial-greeter:quarkus
        env:
        - name: MESSAGE_PREFIX
          value: GreeterV2
```

Deploy the Greeter v2 Service Revision by executing: `oc apply -n serverless-tutorial -f 03-traffic-distribution/greeter-v2-service.yaml`{{execute}}

See that the two Greeter Services have deployed successfully by executing `oc -n serverless-tutorial get revisions.serving.knative.dev`{{execute}}

> **Tip:** *Add `-oyaml` to the command above to see more detail.*

The last command should output two revisions, `greeter-v1` and `greeter-v2`.

```bash
NAME         CONFIG NAME   K8S SERVICE NAME   GENERATION   READY   REASON
greeter-v1   greeter       greeter-v1         1            True
greeter-v2   greeter       greeter-v2         2            True
```

It is important to notice that by default the latest revision will replace the previous by receiving 100% of the traffic.  We can see that inspecting the `.status.traffic` in the output of the following command: `oc get routes.serving.knative.dev greeter -oyaml | yq -y .status.traffic`{{execute}}

```bash
- latestRevision: true
  percent: 100
  revisionName: greeter-v2
```

## Blue-Green Deployment Patterns
Serverless offers a simple way of switching 100% of the traffic from one Serverless service revision (blue) to another newly rolled out revision (green).  We can rollback to a previous revision if any new revision (e.g. green) has erroneous behaviors.

With the deployment of `greeter-v2` you noticed that Serverless automatically started to direct 100% of the traffic to `greeter-v2`. Now let us assume that we need to roll back `greeter-v2` to `greeter-v1` for some critical reason.

The following revision configuration is identical to the previously deployed `greeter-v2` revision except that we have added a `traffic` section to indicate that 100% of the traffic should be routed to `greeter-v1`.

```yaml
# ./assets/03-traffic-distribution/service-pinned.yaml

apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: greeter
  namespace: serverless-tutorial
spec:
  template:
    spec:
      containers:
      - image: quay.io/rhdevelopers/knative-tutorial-greeter:quarkus
        env:
        - name: MESSAGE_PREFIX
          value: GreeterVlatest
        livenessProbe:
          httpGet:
            path: /healthz
        readinessProbe:
          httpGet:
            path: /healthz
  traffic:
  - tag: current
    revisionName: greeter-v1
    percent: 100
  - tag: prev
    revisionName: greeter-v2
    percent: 0
  - tag: latest
    latestRevision: true
    percent: 0 

```

The above service definition creates three sub-routes(named after traffic tags) to the existing `greeter` route.
- **current**: The revision will receive 100% of the traffic distribution
- **prev**: The previously active revision, which will now receive no traffic
- **latest**: The route pointing to the latest service deployment, here we change the default configuration to receive no traffic.

> **Note:** *Be sure to notice the special tag: `latest` in our configuration above.  In the configuration we defined 100% of the traffic be handled by `greeter-v1`.*
>
> *Using the latest tag as such can allow you to change the default behavior of Serverless Services to route 100% of the traffic to the latest revision.*

Before you apply the resource above, call the `greeter` service again to verify that it is still providing the response from `greeter-v2`.  We can do so by validating the response includes `GreeterV2` by reloading the URL to our Service: `curl http://greeter-serverless-tutorial-ks.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute}}

The output should be similar to: `GreeterV2  greeter => '9861675f8845' : 1`

Now update the Serverless Service Configuration using the command by executing: `oc -n serverless-tutorial apply -f 03-traffic-distribution/service-pinned.yaml`{{execute}}

We can see the sub-routes: `oc -n serverless-tutorial get ksvc greeter -oyaml | yq -y .status.traffic`{{execute}}

The above command should return you three sub-routes for the main greeter route:
- *The sub route for the traffic tag current:* http://current-greeter-serverless-tutorial-ks.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com
- *The sub route for the traffic tag prev:* http://prev-greeter-serverless-tutorial-ks.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com
- *The sub route for the traffic tag latest:* http://latest-greeter-serverless-tutorial-ks.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com

The configuration change we issued above does not create any new `configuration`, `revision`, or `deployment` as there was no application update (e.g. image tag, env var, etc).  You might notice that when you call the service withoug the sub-route, Serverless scales up the `greeter-v1`, as our configuration specifies and the service responds with the text `Hi greeter ⇒ '9861675f8845' : 1`.

We can check that `greeter-v1` is receiving 100% of the traffic now to our main route by executing: `curl http://greeter-serverless-tutorial-ks.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute}}

> **Challenge:** *As a test, route all of the traffic back to `greeter-v2` (green).*
>
> *You can edit the `03-traffic-distribution/service-pinned.yaml` and run `oc replace -f <file>` or just run `oc edit services.serving.knative.dev greeter`.*
>
> *After you make the changes and apply them, try calling the service again to notice the difference. If everything went smooth you will notice the service calls will now go to only `greeter-v2`.*

Congrats! You now are able to apply a a `blue-green` deployment pattern using Serverless.  In the next section we will look at `canary release` deployments.

