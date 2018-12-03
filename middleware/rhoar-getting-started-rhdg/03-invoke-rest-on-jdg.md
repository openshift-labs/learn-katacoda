Red Hat Data Grid (RHDG) supports REST out of the box so you can invoke cache operations with these HTTP methods:

* `GET`: retrieves cache entries.
* `POST`: creates new cache entries under specified keys.
* `DELETE`: deletes cache entries.
* `PUT`: updates cache entries.

The URLs through which you invoke cache operations contain cache and key namesIn addition, the invocation URL contains cache name and key name in its address. You'll see this encoding method in the examples below.

**1. Retrieving cache entries**

Invoke a `GET` operation on the key named "a" in the cache named "default" with the following command:

`curl -i -H "Accept:application/json" http://rhdgroute-example.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/default/a`{{execute}}

As expected, key "a" does not exist in the default cache and the command returns a `404` HTTP error:

```console
HTTP/1.1 404 Not Found
Server: nginx/1.11.9
Date: Wed, 24 Jan 2018 15:28:22 GMT
Content-Type: text/plain; charset=utf-8
Content-Length: 0
Connection: keep-alive
```

**2. Inserting entries into the cache**

Insert a JSON entry `{"name":"Red Hat Data Grid"}` as the value for the key named "a" in the default cache with the following command:

`curl -X POST -i -H "Content-type:application/json" -d "{\"name\":\"Red Hat Data Grid\"}"  http://rhdgroute-example.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/default/a`{{execute}}

Now key "a" exists in the default cache and has a JSON value. If you retrieve the entry again, it is successful:

`curl -i -H "Accept:application/json" http://rhdgroute-example.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/default/a`{{execute}}

**3. Updating cache entries**

Update the cache entry and replace the value of key "a" with a different JSON entry `{"name":"Infinispan"}` with the following command:

`curl -X PUT -i -H "Content-type:application/json" -d "{\"name\":\"Infinispan\"}"  http://rhdgroute-example.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/default/a`{{execute}}

Retrieve the entry again to verify the updated value:

`curl -i -H "Accept:application/json" http://rhdgroute-example.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/default/a`{{execute}}

**4. Deleting cache entries**

Delete key "a" from the default cache with the following command:

`curl -X DELETE -i http://rhdgroute-example.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/default/a`{{execute}}

Attempt to retrieve the entry to verify that it is deleted:

`curl -i -H "Accept:application/json" http://rhdgroute-example.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/rest/default/a`{{execute}}

A `404` HTTP error is returned because you deleted the entry from the cache.

## Congratulations

Now that you've successfully completed this tutorial you're ready to start learning more about RHDG capabilities.

Head over to the [Quickstarts on GitHub](https://github.com/jboss-developer/jboss-jdg-quickstarts) where you can find code examples with how-to and best practice demonstrations for running RHDG on OpenShift.

You can also find lots of information in the [Red Hat Data Grid documentation](https://access.redhat.com/documentation/en/red-hat-data-grid/).
