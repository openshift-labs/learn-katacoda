Now that we've deployed, started, and exposed JDG instance on Openshift platform, let's invoke simple cache
put/get/delete operations over REST.

REST support comes out-of-the-box with JDG instance. We can invoke cache operations with appropriate HTTP methods:

* GET: retrieves a cache entry
* POST: creates a new cache entry under a specified key  
* DELETE: deletes a cache entry
* PUT: updates a cache entry  

In addition, the invocation URL contains cache name and key name in its address. You'll see this encoding method in the examples below. Ok, let's go over all these operations one-by-one.

**1. Invoke cache get operation**

We'll invoke get cache operation on cache default with the key "a" with the following curl command

```curl -i -H "Accept:application/json" http://jdgroute-example.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/default/a```{{execute}}

As expected, we don't have any value under key "a" in cache named default and therefore we'll get HTTP 404 error. You should see the following output after the above invocation:

```console
HTTP/1.1 404 Not Found
Server: nginx/1.11.9
Date: Wed, 24 Jan 2018 15:28:22 GMT
Content-Type: text/plain; charset=utf-8
Content-Length: 0
Connection: keep-alive
```

**2. Invoke cache put operation**

Let's change that and insert JSON entry {"name":"JBoss Data Grid"} under the key "a" in cache default:

```curl -X POST -i -H "Content-type:application/json" -d "{\"name\":\"JBoss Data Grid\"}"  http://jdgroute-example.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/default/a```{{execute}}

Now that we've inserted the JSON value under the key "a" let's invoke get cache operation on cache default with key "a" once again:

```curl -i -H "Accept:application/json" http://jdgroute-example.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/default/a```{{execute}}

**3. Invoke cache replace operation**

Let's update our cache entry and replace value under key "a" with value {"name":"Infinispan"}.

```curl -X PUT -i -H "Content-type:application/json" -d "{\"name\":\"Infinispan\"}"  http://jdgroute-example.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/default/a```{{execute}}

And verify that we've indeed replaced value {"name":"JBoss Data Grid"} with {"name":"Infinispan"}.

```curl -i -H "Accept:application/json" http://jdgroute-example.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/default/a```{{execute}}

**4. Invoke cache delete operation**

We can also delete cache entries. Let's delete entry under key "a"

```curl -X DELETE -i http://jdgroute-example.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/default/a```{{execute}}

And verify that we've indeed deleted the entry by invoking get operation again:

```curl -i -H "Accept:application/json" http://jdgroute-example.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/default/a```{{execute}}

That's all, it's really that simple and easy to invoke cache operations over REST on JDG.  

## Congratulations

You have now successfully executed all steps in this scenario.
