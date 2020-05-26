# Todo, integrate this section throughout the tutorial instead of leaving it to the end.

# Knative Client
Knative Client is the command line utility aimed at enhancing the developer experience when doing Serverless Serving and Eventing tasks.

At the end of this chapter you will be able to :
- Install Knative Client
- Create, update, list and delete Serverless service
- Create, update, list and delete Serverless service revisions
- List Serverless service routes

* Warning: Knative Client (kn) is still under aggressive development, so commands and options might change rapidly.
As of writing the tutorial v0.12.0 was the latest version of the Knative Client*

## Install
#TODO Include link of where to get this, but it should already be installed in the env.

## Serverles Service Commands
In the previous chapter you created, updated and deleted the Serverless service using the YAML and oc command line tools.

We will perform the same operations in this chapter but with kn:

## Create Service
To create the `greeter` service using `kn` run the following command: `kn service create greeter --namespace serverless-tutorial --image quay.io/rhdevelopers/knative-tutorial-greeter:quarkus`{{execute}}

A successful create of the greeter service should show a response like

```bash
Service 'greeter' successfully created in namespace 'serverless-tutorial'.
Waiting for service 'greeter' to become ready ... OK

Service URL:
http://greeter.serverless-tutorial.example.com
```

## List Serverless Services
You can list the created services using the command: `kn service list --namespace serverless-tutorial`{{execute}}

## Invoke Service
```
export SVC_URL=`oc get rt greeter -o yaml | yq read - 'status.url'` && http $SVC_URL
```
{{execute}}

You can verify what you the kn client has deployed, to make sure its inline with what you have see in previous chapter.

## Update Serverless Service
To create a new revision using kn is as easy as running another command.

In previous chapter we deployed a new revision of Serverless service by adding an environment variable. Lets try do the same thing with kn to trigger a new deployment:
`kn service update greeter --env "MESSAGE_PREFIX=Namaste"`{{execute}}

Now Invoking the service will return me a response like **Namaste greeter ⇒ '9861675f8845' : 1**

## Describe Serverless Service
Sometime you wish you get the YAML of the Serverless service to build a new service or to compare with with another service. kn makes it super easy for you to get the YAML:

`kn service describe greeter`{{execute}}

The describe should show you an exhaustive YAML like
```yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  annotations:
    serving.knative.dev/creator: minikube-user
    serving.knative.dev/lastModifier: minikube-user
  creationTimestamp: "2019-08-05T12:51:40Z"
  generation: 2
  name: greeter
  namespace: serverless-tutorial
  resourceVersion: "35193"
  selfLink: /apis/serving.knative.dev/v1/namespaces/serverless-tutorial/services/greeter
  uid: c4ee1f47-b77f-11e9-96b1-22e0f431a3ed
spec:
  template:
    metadata:
      creationTimestamp: null
    spec:
      containers:
      - env:
        - name: MESSAGE_PREFIX
          value: '''Namaste'''
        image: quay.io/rhdevelopers/knative-tutorial-greeter:quarkus
        name: user-container
        resources: {}
      timeoutSeconds: 300
  traffic:
  - latestRevision: true
    percent: 100
status:
  address:
    url: http://greeter.serverless-tutorial.svc.cluster.local
  conditions:
  - lastTransitionTime: "2019-08-05T13:03:33Z"
    status: "True"
    type: ConfigurationsReady
  - lastTransitionTime: "2019-08-05T13:03:33Z"
    status: "True"
    type: Ready
  - lastTransitionTime: "2019-08-05T13:03:33Z"
    status: "True"
    type: RoutesReady
  latestCreatedRevisionName: greeter-578mv
  latestReadyRevisionName: greeter-578mv
  observedGeneration: 2
  traffic:
  - latestRevision: true
    percent: 100
    revisionName: greeter-578mv
  url: http://greeter.serverless-tutorial.example.com
```

## Delete Serverless Service
*If you are going to work with other kn commands Revisions and Routes, then run these exercises after those commands*

You can also use kn to delete the service that were created, to delete the service named greeter run the following command:

`kn service delete greeter`{{execute}}

A successful delete should show an output like

`Service 'greeter' successfully deleted in namespace 'serverless-tutorial'.`

Listing services you will notice that the greeter service no longer exists.

# Serverless Revision Commands
The kn revision commands are used to interact with revision(s) of Serverless service.

## List Revisions
You can list the available revisions of a Serverless service using: `kn revision list`{{execute}}

The command should show a list of revisions like
```
NAME            SERVICE   AGE   CONDITIONS   READY   REASON
greeter-7cqzq   greeter   11s   4 OK / 4     True
greeter-qctxv   greeter   56s   4 OK / 4     True
```

## Describe Revision
To get the details about a specific revision you can use the command: `kn revision describe greeter-7cqzq`{{execute}}

The command should return a YAML like
```yaml
apiVersion: serving.knative.dev/v1
kind: Revision
metadata:
  annotations:
    serving.knative.dev/lastPinned: "1565062128"
  creationTimestamp: "2019-08-06T03:28:42Z"
  generateName: greeter-
  generation: 1
  labels:
    serving.knative.dev/configuration: greeter
    serving.knative.dev/configurationGeneration: "2"
    serving.knative.dev/service: greeter
  name: greeter-7cqzq
  namespace: serverless-tutorial
  ownerReferences:
  - apiVersion: serving.knative.dev/v1
    blockOwnerDeletion: true
    controller: true
    kind: Configuration
    name: greeter
    uid: 2f89f930-b7fa-11e9-96b1-22e0f431a3ed
  resourceVersion: "40312"
  selfLink: /apis/serving.knative.dev/v1/namespaces/serverless-tutorial/revisions/greeter-7cqzq
  uid: 49e30221-b7fa-11e9-96b1-22e0f431a3ed
spec:
  containers:
  - env:
    - name: MESSAGE_PREFIX
      value: Namaste
    image: quay.io/rhdevelopers/knative-tutorial-greeter:quarkus
    name: user-container
    resources: {}
  timeoutSeconds: 300
status:
  conditions:
  - lastTransitionTime: "2019-08-06T03:29:51Z"
    message: The target is not receiving traffic.
    reason: NoTraffic
    severity: Info
    status: "False"
    type: Active
  - lastTransitionTime: "2019-08-06T03:28:48Z"
    status: "True"
    type: ContainerHealthy
  - lastTransitionTime: "2019-08-06T03:28:48Z"
    status: "True"
    type: Ready
  - lastTransitionTime: "2019-08-06T03:28:48Z"
    status: "True"
    type: ResourcesAvailable
  imageDigest: quay.io/rhdevelopers/knative-tutorial-greeter@sha256:767e2f4b37d29de3949c8c695d3285739829c348df1dd703479bbae6dc86aa5a
  logUrl: http://localhost:8001/api/v1/namespaces/knative-monitoring/services/kibana-logging/proxy/app/kibana#/discover?_a=(query:(match:(kubernetes.labels.knative-dev%2FrevisionUID:(query:'49e30221-b7fa-11e9-96b1-22e0f431a3ed',type:phrase))))
  observedGeneration: 1
  serviceName: greeter-7cqzq
```

## Delete Revision
To delete a specific revision you can use the command: `kn revision delete greeter-7cqzq`{{execute}}

The command should return an output like

`Revision 'greeter-7cqzq' successfully deleted in namespace 'serverless-tutorial'.`

Now invoking service will return the response from revision `greeter-6m45j`.

# Serverless Route Commands
The kn revision commands are used to interact with route(s) of Serverless service.

## List Routes
`kn route list`{{execute}}

The command should return an output like
```bash
NAME      URL                                          AGE   CONDITIONS   TRAFFIC
greeter   http://greeter.serverless-tutorial.example.com   10m   3 OK / 3     100% -> greeter-zd7jk
```

*TIP: As an exercise you can run the exercises of previous chapter and try listing the routes using kn.*

## Cleanup
`kn service delete greeter`{{execute}}
