We are now ready to change our application to use ConfigMaps!

In the sample application, this is the hard-coded message that is returned to the caller of the service:

```javascript
let message = "Default hard-coded greeting: Hello, %s!";
```

We'll override this value by periodically retrieving a ConfigMap and overriding the value of `message`.

** 1. Add timed interval to retrieve config**

In `app.js`{{open}} add a new block of code that is executed every 2 seconds that retrieves the message value and overrides
the variable. Click the **Copy to Editor** button below to place this code in `app.js`{{open}}:

<pre class="file" data-filename="app.js" data-target="insert" data-marker="// TODO: Periodic check for config map update">
setInterval(() => {
  retrieveConfigMap().then((config) => {
    if (!config) {
      message = null;
      return;
    }

    if (JSON.stringify(config) !== JSON.stringify(configMap)) {
      configMap = config;
      message = config.message;
    }
  }).catch((err) => {
    console.log("error: ", err);
  });
}, 2000);

</pre>

We are using [Promise chaining](https://javascript.info/promise-chaining) to write
efficient yet readable asynchronous method call chains to retrieve the ConfigMap.

The above method calls `setInterval()` (a [Node.js interval timer](https://nodejs.org/api/timers.html)) to periodically invoke `retrieveConfigMap()` which
returns a _promise_ object which, once complete, which will return the ConfigMap object named `config` and pass it to the callback to override the value
of `message`. We catch and ignore errors for the purposes of this sample.

Now that we have the logic in place to update the value, we need to implement the missing `retrieveConfigMap()` method which
will need to return a _promise_ to call into OpenShift and retrieve the ConfigMap content itself.

**2. Add ConfigMap retrieval logic**

Click on **Copy To Editor** below to implement the logic in `app.js`{{open}}

<pre class="file" data-filename="app.js" data-target="insert" data-marker="// TODO: Retrieve ConfigMap">
// Find the Config Map
const openshiftRestClient = require('openshift-rest-client').OpenshiftClient;
const config = require('openshift-rest-client').config;
const customConfig = config.getInCluster();

async function retrieveConfigMap() {
  const client = await openshiftRestClient({config: customConfig});
  const configmap = await client.api.v1.namespaces('example').configmaps('app-config').get();
  return jsyaml.safeLoad(configmap.body.data['app-config.yml']);
}
</pre>

In this code we are returning yet another _promise_ (using JavaScript's [async functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function) ) which will be responsible for using
the [openshift-rest-client](https://www.npmjs.com/package/openshift-rest-client) module to make the call to the OpenShift REST API and retrieve the ConfigMap.

The use of promises and async may take a little getting used to, but ultimately it results in an ordered and well-defined
process to retrieve the ConfigMap from OpenShift, parse it into a Javascript-friendly JSON object, and use it to override
the value of our `message` variable so that we can control its value externally, without requiring any changes in the
application code. The final chain called every 2 seconds looks something like:

`openshiftRestClient -> retrieve ConfigMap using .find('app-config') -> convert yaml to json ->  override message value`

With our new logic in place, we can now create the actual ConfigMap within OpenShift which will contain the config
vales accessed by the logic.
