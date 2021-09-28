# Types of Data Grid services

Data Grid has two types of services:

* `Cache` Service - if you want a volatile, low-latency data store with minimal configuration. Cache Service nodes automatically scale based on capacity pressure, synchronously distributes and replicates but are volatile and are reset if you reconfigure or delete the underlying Data Grid cluster.

* `DataGrid` Service - enables backing up data across global clusters using cross-site replication, can persist data in the grid, can issue queries across caches using the Data Grid Query API, and othert advanced features.

You might have noticed that in our first exercise we created the Cache service (the default type) in the upcoming exercises we will use other types.

## Create cache

Let's create a simple cache in our cache service using the command line. Click on the following to create a new Cache custom resource (this could also be done via the web console):

```
oc apply -f - << EOF
apiVersion: infinispan.org/v2alpha1
kind: Cache
metadata:
  name: mycachedefinition
spec:
  clusterName: datagrid-service
  name: mycache
EOF
```{{execute}}

This creates a basic cache called `mycache`. There are [many](https://access.redhat.com/documentation/en-us/red_hat_data_grid/8.2/html-single/configuring_data_grid/index#cache_modes), _many_ options for configuring caches but we'll just stick with the defaults for now.

You can see it in the [Data Grid Admin console](https://my-dg-dgdemo.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/console), you can see the new cache:

> **NOTE**: You may need to reload the browser page to see it!

![Operator](/openshift/assets/middleware/dg/dgnewcache.png)

## Adding data

Let's add some data! We'll use the Data Grid REST interface to add it. Click this command to add some random data to the `mycache` cache:

```
for i in {1..100} ; do
  curl -H 'Content-Type: text/plain' -k -u developer:$PASSWORD -X POST -d "myvalue$i" https://my-dg-dgdemo.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/v2/caches/mycache/mykey$i
  echo "Added mykey$i:myvalue$i"
done
```{{execute}}

This will add 100 entries under keys `mykey1`, `mykey2`, ... with values `myvalue1`, `myvalue2`...

You can see the entries in the [cache overview in the admin console](https://my-dg-dgdemo.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/console/cache/mycache):

> You may need to click on the **Entries** tab.

![Operator](/openshift/assets/middleware/dg/entries.png)

You can view, edit and delete these entries graphically, through REST, or other protocols such as HotRod depending on your application and performance needs.

## Access via REST

Red Hat Data Grid supports REST out of the box so you can invoke cache operations with these HTTP methods:

* `GET`: retrieves cache entries.
* `POST`: creates new cache entries under specified keys.
* `DELETE`: deletes cache entries.
* `PUT`: updates cache entries.

The URLs through which you invoke cache operations contain cache and key names. In addition, the invocation URL contains cache name and key name in its address. You'll see this encoding method in the example below.

Let's retrieve one of our cache entries. Click the following command:

`curl -k -u developer:$PASSWORD https://my-dg-dgdemo.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/v2/caches/mycache/mykey22`{{execute}}

You should see its value returned `myvalue22`.

Now update it:

`curl -H 'Content-Type: text/plain' -k -u developer:$PASSWORD -X PUT -d "mynewvalue22" https://my-dg-dgdemo.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/v2/caches/mycache/mykey22`{{execute}}

This updates the value to `mynwvalue22`. Retrieve it to verify:

`curl -k -u developer:$PASSWORD https://my-dg-dgdemo.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/v2/caches/mycache/mykey22`{{execute}}

Now lets delete it:

`curl -k -u developer:$PASSWORD -X DELETE https://my-dg-dgdemo.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/v2/caches/mycache/mykey22`{{execute}}

And retrieve it (it will fail with `HTTP 404`):

`curl -i -k -u developer:$PASSWORD https://my-dg-dgdemo.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/v2/caches/mycache/mykey22`{{execute}}

This demonstrates basic RESTful access to Data Grid.

## Viewing metrics

The admin console has built in metrics about each cache. Click the _Metrics_ tab to see them:

![Operator](/openshift/assets/middleware/dg/adminmetrics.png)

You can also visit the [Global Metrics](https://my-dg-dgdemo.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/console/global-stats) screen to see more info about the Data Grid service as a whole, and confirm cluster status and the 2 replicas on the [Cluster Membership](https://my-dg-dgdemo.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/console/cluster-membership) screen.


