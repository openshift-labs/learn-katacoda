At this point we have the KubeFed Control Plane up and running with both clusters registered.

Now we are going to deploy a federated application. This application is a nginx web server serving a welcome page. Despite its simplicity, it will help us to understand how federation works.

Before creating the application objects, we need to enable the types we want to federate, in this case:

* `namespaces`
* `secrets`
* `serviceaccounts`
* `services`
* `configmaps`
* `deployments.apps`

Enabling `namespaces` is required so the KubeFed controller will propagate namespaces across the federated clusters.

```
for type in namespaces secrets serviceaccounts services configmaps deployments.apps
do
  /usr/local/bin/kubefedctl enable $type --kubefed-namespace test-namespace
done
```{{execute HOST1}}

Some k8s objects are required:

* A k8s `Namespace`, `test-namespace` which is already created

You can verify that the namespace is created on both clusters:

``oc --context=cluster1 get ns | grep test-namespace``{{execute HOST1}}

``oc --context=cluster2 get ns | grep test-namespace``{{execute HOST1}}

At this point we are ready to deploy the application. This sample application includes the following resources:

* A [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) of an nginx web server.
* A [Service](https://kubernetes.io/docs/concepts/services-networking/service/) of type NodePort for nginx.

*NOTE:* A sample ConfigMap, Secret and ServiceAccount are also created to illustrate how federation would assist with more complex applications but will not be used in this scenario.

The [sample-app directory](https://github.com/openshift/federation-dev/tree/katacoda/sample-app) included in the Git repository, contains definitions to deploy these resources. For each of them there is a resource template which includes a placement policy, and some of them also have overrides. For example: the [sample nginx deployment template](https://github.com/openshift/federation-dev/blob/katacoda/sample-app/federateddeployment.yaml) specifies 3 replicas, but there is also [an override](https://github.com/openshift/federation-dev/blob/katacoda/sample-app/federateddeployment.yaml#L28-L32) that sets the replicas to 5 on `cluster2`.

Overrides can be used to specify different values for some attributes across clusters, in this course we use an override to control the replicas over the different clusters as explained above. Imagine you want your application running on-premise to have 3 replicas and 5 replicas for the application running on the cloud, you will use an override for that.

Instantiate all these federated resources:

``oc --context=cluster1 apply -R -f sample-app/``{{execute HOST1}}

After some seconds we will have the application up and running. Do not worry about the warnings, you can check that everything is okay running the following snippet:

```
for resource in configmaps secrets deployments services; do
    for cluster in cluster1 cluster2; do
        echo ------------ ${cluster} ${resource} ------------
        oc --context=${cluster} -n test-namespace get ${resource}
    done
done
```{{execute HOST1}}
