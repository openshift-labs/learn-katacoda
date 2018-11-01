# Make Some Changes

Now that we have a working application deployed to OpenShift lets play around with it a little bit. Currently the application allows us to add fruits regardless of if they have been added before. What if we wanted to limit this basket to only hold one type of each fruit at any given time?

Let's update the Controller to enforce this new requirement and the view to notify the user of this behavior (it looks like the app is broken otherwise!).

**1. Update the Controller**

First we will update the Controller. Go ahead and open that file in the editor: 

Currently in the `@PostMapping` method we simply do a `fruits.add(fruit);` action without any checks for deduping. For the sake of simplicity we will simply ignore submissions if the fruit already exists. We can use a little Java 8 Stream to accomplish this. Open ``src/main/java/com/example/service/FruitController.java``{{open}} and replace the `fruits.add(fruit);` line with the following:

<pre class="file" data-filename="rc/main/java/com/example/service/FruitController.java" data-target="insert" data-marker="fruits.add(fruit);">
if(fruits.stream().noneMatch(f -> f.getName().equalsIgnoreCase(fruit.getName()))) {
    fruits.add(fruit);
}
</pre>

The `noneMatch()` combinator returns true only if there are no elements in the Stream which match the given predicate. In this case it will return true only if there is no Fruit in the list whose name matches (ignoring case) the submitted Fruit's name. Using this - we can add to the `fruits` list only if a Fruit with the same name does not already exist!

**2. Update the View**

Next let's update the view to notify the user of the de-duping behavior. Open the Home view `src/main/resources/templates/home.html`{{open}} and copy the following at the `<!-- TODO: View Update -->` Marker (or click the `Copy to Editor` button):

<pre class="file" data-filename="src/main/resources/templates/home.html" data-target="insert" data-marker="<!-- TODO: View Update -->">
&lt;p&gt;(Duplicates will be ignored)&lt;/p&gt;
</pre>

Just a simple sub-text under the header!

**3. Re-deploy the Application**

Before re-deploying we want to verify locally that our changes are correct. Run ``mvn spring-boot:run``{{execute}}. When the console reports that the app is up and running access the web page by using [this link](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/fruits). If you type `Apple` and click `Save` twice it should only show one entry for Apple. If all is working locally press <kbd>CTRL</kbd>+<kbd>C</kbd> to stop the running application.

All that's left now is to re-run the `fabric8:deploy` command to re-deploy the application to OpenShift:

``mvn package fabric8:undeploy fabric8:deploy -Popenshift``{{execute}}

After deployment completes either go to the OpenShift web console and click on the route or click [here](http://rhoar-training-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/fruits). We can confirm that our application is still up and working just as it was before! The only difference now is that it's deployed on OpenShift.

## Congratulations

You have now learned how to deploy a Spring Boot MVC application to OpenShift Container Platform. 

Click Summary for more details and suggested next steps.
