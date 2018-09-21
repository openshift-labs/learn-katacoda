Wait only N seconds before giving up and failing. 

First, introduce some wait time in recommendations v2 by uncommenting the line 48 that call the timeout method. This method, will cause a wait time of 3 seconds. Update `/recommendation-v2/src/main/java/com/redhat/developer/demos/recommendation/RecommendationVerticle.java`{{open}} making it a slow perfomer. 

<pre class="file">
       @Override
       public void start() throws Exception {
           Router router = Router.router(vertx);
           router.get("/").handler(this::timeout);
           router.get("/").handler(this::logging);
           router.get("/").handler(this::getRecommendations);
//         router.get("/").handler(this::getNow);
           router.get("/misbehave").handler(this::misbehave);
           router.get("/behave").handler(this::behave);

           HealthCheckHandler hc = HealthCheckHandler.create(vertx);
           hc.register("dummy-health-check", future -> future.complete(Status.OK()));
           router.get("/health").handler(hc);

           vertx.createHttpServer().requestHandler(router::accept).listen(LISTEN_ON);
       }
</pre>

**Note:** The file is saved automatically.

Rebuild and redeploy the recommendation microservices.

Go to the recommendation folder `cd ~/projects/istio-tutorial/recommendation-v2/`{{execute T1}}

Compile the project with the modifications that you did.

`mvn package`{{execute T1}}

Execute `docker build -t example/recommendation:v2 .`{{execute T1}}

You can check the image that was create by typing `docker images | grep recommendation`{{execute T1}}

Now let's delete the previous v2 pod to force the creation of a new pod using the new image.

`oc delete pod -l app=recommendation,version=v2 -n tutorial`{{execute T1}}

To watch the creation of the pods, execute `oc get pods -w`{{execute T1}}

Once that the recommendation pods READY column are 2/2, you can hit `CTRL+C`. 

Check `Terminal 2` and make sure that you can see `v2` responding in 3 seconds: `while true; do time curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute interrupt T2}}


## Timeout rule

Check the file `/istiofiles/virtual-service-recommendation-timeout.yml`{{open}}.

Note that this `VirtualService` provides a `timeout` of `1 second`.

Let's apply this rule: `istioctl create -f ~/projects/istio-tutorial/istiofiles/virtual-service-recommendation-timeout.yml -n tutorial`{{execute interrupt T1}}

You should see it return `v1` OR `504 upstream request timeout` after waiting about 1 second, although v2 takes 3 seconds to complete.

To check this behavior, send several requests to the microservices on `Terminal 2` to see their responses
`while true; do time curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute T2 }}

## Clean up

To remove the Timeout behavior, simply delete this `VirtualService` by executing `istioctl delete -f ~/projects/istio-tutorial/istiofiles/virtual-service-recommendation-timeout.yml -n tutorial`{{execute T1}}

To check if you have random load-balance with `v2` replying in 3 seconds, try the microservice on `Terminal 2`: `while true; do time curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute T2 }}
