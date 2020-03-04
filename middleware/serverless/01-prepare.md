# Verify Installation

Check all pods are running in `knative-serving` namespace by executing the command `oc get -n knative-serving pods`{{execute T1}}

If the install was successful you should see the following pods in `knative-serving` namespace with the *Status* of `Running`:

```shell
NAME                                READY   STATUS    RESTARTS   AGE
activator-d6478496f-qp89p           1/1     Running   0          90s
autoscaler-6ff6d5659c-4djrt         1/1     Running   0          88s
autoscaler-hpa-868c8b56b4-296rc     1/1     Running   0          89s
controller-55b4748bc5-ndv4p         1/1     Running   0          84s
networking-istio-679dfcd5d7-2pbl4   1/1     Running   0          82s
webhook-55b96d44f6-sxj7p            1/1     Running   0          84s
```

## Login as developer

To deploy the exercises, you need to use `developer` user. Login as developer user `oc login -u developer -p developer`{{execute T1}}

> **NOTE**
>
> Ignore *Warning: User 'developer' not found*. This happens as you have not logged in yet as `developer`


There we go! You are all set to kickstart your serverless journey with **OpenShift Serverless**. Click continue to go to next module on how to deploy your first severless service.
