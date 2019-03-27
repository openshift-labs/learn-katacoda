Next step in this scenario is to remove our application from `cluster2` while keep it running in `cluster1`. To perform the operation, we are going to patch the `FederatedNamespace` placement policy for `test-namespace` so it will only live on `cluster1`:

``oc --context=cluster1 -n test-namespace patch federatednamespace test-namespace --type=merge -p '{"spec":{"placement":{"clusterNames": ["cluster1"]}}}'``{{execute HOST1}}

Now we should see our application evacuating `cluster2`, including all the objects such as services, secrets, etc:

```
for resource in configmaps secrets deployments services; do
    for cluster in cluster1 cluster2; do
        echo ------------ ${cluster} ${resource} ------------
        oc --context=${cluster} -n test-namespace get ${resource}
    done
done
```{{execute HOST1}}

If we wanted to deploy our application to `cluster2` again, we could patch the `FederatedNamespace` placement policy again:

``oc --context=cluster1 -n test-namespace patch federatednamespace test-namespace --type=merge -p '{"spec":{"placement":{"clusterNames": ["cluster1", "cluster2"]}}}'``{{execute HOST1}}

After a while, we should see our application deployed on `cluster2`:

```
for resource in configmaps secrets deployments services; do
    for cluster in cluster1 cluster2; do
        echo ------------ ${cluster} ${resource} ------------
        oc --context=${cluster} -n test-namespace get ${resource}
    done
done
```{{execute HOST1}}
