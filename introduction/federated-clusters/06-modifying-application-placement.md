Next step in this scenario is to remove our application from `cluster2` while keep it running in `cluster1`. To perform the operation, we are going to patch the `FederatedDeployment` placement policy for `test-deployment` so it will only live on `cluster1`:

``oc --context=cluster1 -n test-namespace patch federateddeployment test-deployment --type=merge -p '{"spec":{"placement":{"clusters": [{"name":"cluster1"}]}}}'``{{execute HOST1}}

Now we should see our application deployment evacuating `cluster2`:

```
for cluster in cluster1 cluster2; do
    echo ------------ ${cluster} deployments ------------
    oc --context=${cluster} -n test-namespace get deployments -l app=nginx
done
```{{execute HOST1}}

If we wanted to deploy our application to `cluster2` again, we could patch the `FederatedDeployment` placement policy again:

``oc --context=cluster1 -n test-namespace patch federateddeployment test-deployment --type=merge -p '{"spec":{"placement":{"clusters": [{"name":"cluster1"}, {"name":"cluster2"}]}}}'``{{execute HOST1}}

After a while, we should see our application deployment deployed on `cluster2`:

```
for cluster in cluster1 cluster2; do
    echo ------------ ${cluster} deployments ------------
    oc --context=${cluster} -n test-namespace get deployments -l app=nginx
done
```{{execute HOST1}}
