At the end of this step you will be able to:
- Configure a service to use a `Canary Release` deployment pattern

## Applying a Canary Release Pattern
A Canary release is more effective when you want to reduce the risk of introducing new features. Using this type of deployment model allows you a more effective feature-feedback loop before rolling out the change to your entire user base.  Using this deployment approach with Serverless allows you to split the traffic between revisions in increments as small as 1%.

To see this in action, apply the following Serverless service definition that will split the traffic 80% to 20% between `greeter-v1` and `greeter-v2`.

```yaml
# ./assets/04-canary-releases/greeter-canary-service.yaml

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
              value: GreeterV2
          livenessProbe:
            httpGet:
              path: /healthz
          readinessProbe:
            httpGet:
              path: /healthz
  traffic:
    - tag: v1
      revisionName: greeter-v1
      percent: 80
    - tag: v2
      revisionName: greeter-v2
      percent: 20
    - tag: latest
      latestRevision: true
      percent: 0

```

In this service configuration you can see the 80/20 split between v1 and v2 of the greeter service.  We also can see that the current service is set to receive 0% of the traffic using the `latest` tag.

Apply this service configuration by executing: `oc -n serverless-tutorial apply -f 04-canary-releases/greeter-canary-service.yaml`{{execute}}

As in the previous section on Applying Blue-Green Deployment Pattern deployments, the command will not create a new configuration, revision, or deployment.

To observe the new traffic distribution you need to execute the following:

```bash
# ./assets/04-canary-releases/poll-svc-10.bash

#!/usr/bin/env bash
for run in {1..10}
do
  curl http://greeter-serverless-tutorial-ks.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com
done
```{{execute}}

You will see that 80% of the responses are returned from greeter-v1 and 20% from greeter-v2. See the listing below for sample output:

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

We can also notice that two pods are running, representing both greeter-v1 and greeter-v2: `oc get pods -n serverless-tutorial`{{execute}}

```bash
NAME                                     READY   STATUS    RESTARTS   AGE
greeter-v1-deployment-5dc8bd556c-42lqh   2/2     Running   0          29s
greeter-v2-deployment-1dc2dd145c-41aab   2/2     Running   0          20s
```

> **Note:** *If we waited too long to execute the preceding command we might have noticed the services scaling to zero!*
>
> **Challenge:** *As a challenge, adjust the traffic distribution percentages and observe the responses by executing the `poll-svc-10.bash` script again.*

## Delete the Service

We will need to cleanup the project for our next section by executing: `oc -n serverless-tutorial delete services.serving.knative.dev greeter`{{execute}}

Congrats! You now are able to apply a few different deployment patterns using Serverless.  In the next section we will see how we dig a little deeper into the scaling components of Serverless.
