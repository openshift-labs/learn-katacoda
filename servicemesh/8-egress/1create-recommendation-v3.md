We can experiment with Istio routing rules by making a change to RecommendationsController.java.

Open `/recommendation/java/vertx/src/main/java/com/redhat/developer/demos/recommendation/RecommendationVerticle.java`{{open}} in the editor. Now make the following modification.

```java
    private static final String RESPONSE_STRING_FORMAT = "recommendation v3 from '%s': %d\n";
```    
The second change is to change the default output to make a call to http://worldclockapi.com.

Comment the call to get the recommendations.

```java
// router.get("/").handler(this::getRecommendations);
```

and remove the comment the call to get the actual time.

```java
   router.get("/").handler(this::getNow);
```

**Note:** The file is saved automatically. 

Now go to the recommendations folder `cd ~/projects/istio-tutorial/recommendation/java/vertx`{{execute T1}}

Make sure that the file has changed: `git diff`{{execute T1}}.

Compile the project with the modifications that you did.

`mvn package`{{execute T1}}

## Create the recommendation:v3 docker image.

We will now create a new image using `v3`. The `v3`tag during the docker build is significant.

Execute `docker build -t example/recommendation:v3 .`{{execute T1}}

You can check the image that was create by typing `docker images | grep recommendation`{{execute T1}}

## Create a second deployment with sidecar proxy

There is also a 3rd deployment.yml file to label things correctly

Execute: `oc apply -f <(istioctl kube-inject -f ../../kubernetes/Deployment-v3.yml) -n tutorial`{{execute T1}}

To watch the creation of the pods, execute `oc get pods -w`{{execute T1}}

Once that the recommendation pod READY column is 2/2, you can hit `CTRL+C`. 

