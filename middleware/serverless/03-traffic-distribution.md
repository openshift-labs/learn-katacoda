At the end of this chapter you will be able to:
- Providing custom name to deployment
- Understanding advanced deployment techniques
- Apply blue-green deployment pattern
- Apply Canary Release Deployment pattern
- Reduce the service visibility
As you noticed, Knative service always routes traffic to the **latest** revision of the service deployment. It is possible to split the traffic amongst the available revisions.

## Arbitrary Revision Names
By default, Knative generates random revision names for the service based with Knative service’s `metadata.name` as prefix.

The following service deployments will show how to use an arbitrary revision names for the services. The service are exactly same greeter service except that their Revision name is specified using the service revision template spec.

First, deploy the greeter service revision v1 `oc apply -n knativetutorial -f basics/greeter-v1-service.yaml`{{execute}}

Open the greeter service revision v1 that you just deployed. Be sure to see the `spec.template.metadata.name` **/root/projects/knative-tutorial/basics/greeter-v1-service.yaml** `/root/projects/knative-tutorial/basics/greeter-v1-service.yaml`{{open}}

Next, deploy the greeter service revision v2 `oc apply -n knativetutorial -f basics/greeter-v2-service.yaml`{{execute}}

You can open the greeter service revision v2 and compare with v1 if you would like **/root/projects/knative-tutorial/basics/greeter-v2-service.yaml** `/root/projects/knative-tutorial/basics/greeter-v2-service.yaml`{{open}}

Before continuing, double check that two revisions of the greeter service are configured by executing `oc --namespace knativetutorial get rev --selector=serving.knative.dev/service=greeter --sort-by="{.metadata.creationTimestamp}"`{{execute}}

*TIP: add `-oyaml` to the commands above to see more detail*

The last command should output two revisions, `greeter-v1` and `greeter-v2`.

## Applying Blue-Green Deployment Patterns
Knative offers a simple way of switching 100% of the traffic from one Knative service revision (blue) to another newly rolled out revision (green). If the new revision (e.g. green) has erroneous behavior then it is easy to rollback the change.

In this exercise you will applying theBlue/Green deployment pattern with the Knative Service called greeter. You have already deployed two revisions of greeter named `greeter-v1` and `greeter-v2` earlier in this chapter.

With the deployment of `greeter-v2` you noticed that Knative automatically started to routing 100% of the traffic to `greeter-v2`. Now let us assume that we need to roll back `greeter-v2` to `greeter-v1` for some critical reason.

The `service-pinned.yaml` below is identical to the previously deployed `greeter-v2` except that we have added the `traffic` section to indicate that 100% of the traffic should be routed to `greeter-v1`.

Open the `service-pinned.yaml` here: **/root/projects/knative-tutorial/basics/service-pinned.yaml** `/root/projects/knative-tutorial/basics/service-pinned.yaml`{{open}}

The above service definition creates three sub-routes(named after traffic tags) to existing `greeter` route.
- **current**: The revision is going to have all 100% traffic distribution
- **prev**: The previously active revision, which will now have zero traffic
- **latest**: The route pointing to any latest service deployment, by setting to zero we are making sure the latest revision is not picked up automatically.

*NOTE: In the service definition above we added a special tag: `latest`.  Since you have defined that all 100% of traffic goes to `greeter-v1`, this tag can be used to suppress the default behavior of Knative Service to route all 100% traffic to latest revision.*

Before you apply the resource `$BOOK_HOME/basics/service-pinned.yaml`, call the `greeter` service again to verify that it is still providing the response from `greeter-v2` that includes `Namaste`.

```bash
$ $BOOK_HOME/bin/call.sh
Namaste  greeter => '9861675f8845' : 1

$ kubectl get pods
NAME                                    READY   STATUS    AGE
greeter-v2-deployment-9984bb56d-gr4gp   2/2     Running   14s
```

Now apply the update Knative service configuration using the command as shown in following listing: `oc -n knativetutorial apply -f /root/project/knative-tutorial/basics/service-pinned.yaml`{{execute}}

We can see the sub-routes: `oc -n knativetutorial get ksvc greeter -oyaml | yq r - 'status.traffic[*].url'`{{execute}}

The above command should return you three sub-routes for the main greeter route:
- *The sub route for the traffic tag current:* http://current-greeter.knativetutorial.example.com
- *The sub route for the traffic tag prev:* http://prev-greeter.knativetutorial.example.com
- *The sub route for the traffic tag latest:* http://latest-greeter.knativetutorial.example.com

You will notice that the command does not create any new configuration/revision/deployment as there was no application update (e.g. image tag, env var, etc), but when you call the service, Knative scales up the `greeter-v1` and the service responds with the text `Hi greeter ⇒ '9861675f8845' : 1`.

```bash
$ $BOOK_HOME/bin/call.sh
Hi  greeter => '9861675f8845' : 1

$ kubectl get pods
NAME                                     READY   STATUS    AGE
greeter-v1-deployment-6f75dfd9d8-s5bvr   2/2     Running   5s
```

*Tip: As an exercise, flip all the traffic back to `greeter-v2` (green). You need to edit the traffic block of the `service-pinned.yaml` and update the revision name to `greeter-v2`. After you redeploy the `service-pinned.yaml`, try calling the service again to notice the difference. If everything went smooth you will notice the service calls will now go to only `greeter-v2`.*

## Applying a Canary Release Pattern
A Canary release is more effective when you want to reduce the risk of introducing new feature. It allows you a more effective feature-feedback loop before rolling out the change to your entire user base.

Knative allows you to split the traffic between revisions in increments as small as 1%.

To see this in action, apply the following Knative service definition that will split the traffic 80% to 20% between `greeter-v1` and `greeter-v2`.

#TODO Turn this yaml into an asset
```yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: greeter
spec:
  template:
    metadata:
      name: greeter-v2
    spec:
      containers:
        - image: quay.io/rhdevelopers/knative-tutorial-greeter:quarkus
          env:
            - name: MESSAGE_PREFIX
              value: Namaste
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

#TODO `oc -n knativetutorial apply -f service-canary.yaml`

As in the previous section on Applying Blue-Green Deployment Pattern deployments, the command will not create any new configuration/revision/deployment. To observe the traffic distribution you need to run the script $BOOK_HOME/bin/poll.sh, which is almost identical to $BOOK_HOME/bin/call.sh but will invoke the Knative service in a loop.

`$BOOK_HOME/bin/poll.sh`

With the poll.sh script running you will see that approximately 80% of the responses are returned from greeter-v1 and approximately 20% from greeter-v2. See the listing below for sample output:

```bash
Hi  greeter => '9861675f8845' : 1
Hi  greeter => '9861675f8845' : 2
Namaste  greeter => '9861675f8845' : 1
Hi  greeter => '9861675f8845' : 3
Hi  greeter => '9861675f8845' : 4
Hi  greeter => '9861675f8845' : 5
Hi  greeter => '9861675f8845' : 6
Hi  greeter => '9861675f8845' : 7
Hi  greeter => '9861675f8845' : 8
Hi  greeter => '9861675f8845' : 9
Hi  greeter => '9861675f8845' : 10
Hi  greeter => '9861675f8845' : 11
Namaste  greeter => '9861675f8845' : 2
Hi  greeter => '9861675f8845' : 12
Hi  greeter => '9861675f8845' : 13
Hi  greeter => '9861675f8845' : 14
Hi  greeter => '9861675f8845' : 15
Hi  greeter => '9861675f8845' : 16
...
```

You should also notice that two pods are running representing both greeter-v1 and greeter-v2:
```
$ watch kubectl get pods
NAME                                     READY   STATUS    AGE
greeter-v1-deployment-6f75dfd9d8-86q89   2/2     Running   12s
greeter-v2-deployment-9984bb56d-n7xvm    2/2     Running   2s
```

As a challenge, adjust the traffic distribution and observe the responses while the poll.sh script is actively running.

`oc -n knativetutorial delete services.serving.knative.dev greeter`
