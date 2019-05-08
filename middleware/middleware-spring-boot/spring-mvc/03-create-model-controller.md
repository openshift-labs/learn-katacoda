# Create the Fruit Basket Model and Controller

Spring MVC is a framework around the Model/View/Controller pattern which provides the developer with a set of tools and abstractions for building MVC-driven applications. 

**1. Create a Model**

The *M* in MVC, our Model, forms the basis for the domain that we are working with. In Spring MVC models are just plain old Java objects (POJOs). So first we need to create a Java class file that will model our Fruit objects. For that, you need to click on the following link, which opens the empty file in the editor: ``src/main/java/com/example/service/Fruit.java``{{open}}

Then, copy the below content into the file (or use the `Copy to Editor` button):

<pre class="file" data-filename="src/main/java/com/example/service/Fruit.java" data-target="replace">
package com.example.service;

public class Fruit {

    private String name;

    public Fruit() {
    }

    public Fruit(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Fruit{ name='" + name + '\'' + " }";
    }
}
</pre>

As you can see this is a Plain-Old-Java-Object (POJO). Nothing fancy here yet!

**2. Add a Controller**

To make these models available to our application we need to create a Spring Controller. Controllers are the **C** in the MVC pattern which mediate between our views and our internal models / business logic. Here we need to create a Spring `@RestController` annotated Java class. For this you need to click on the following link which will open an empty file in the editor: ``src/main/java/com/example/service/FruitController.java``{{open}}

Then, copy the below content into the file (or use the `Copy to Editor` button):

<pre class="file" data-filename="src/main/java/com/example/service/FruitController.java" data-target="replace">
package com.example.service;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/fruits")
public class FruitController {

    private List&lt;Fruit&gt; fruits = new ArrayList&lt;&gt;();

    @GetMapping
    public String home(Model model) {
        model.addAttribute("fruits", fruits);     // For the List view
        model.addAttribute("fruitForm", new Fruit()); // For the Form
        return "home";
    }

    // TODO POST mapping here
}
</pre>

The `@Controller` annotation is a Spring annotation which marks the annotated class as, you guessed it, a Controller. Spring Boot will search for these annotations (and others) at startup and automatically wire them up to the Servlet Container for us. 

`@RequestMapping` is our way of telling Spring what URI we want this controller to service. When requests come in to our Servlet for the `/fruits` URI it will be routed to this Spring Controller. `@RequestMapping` can also be used on methods which is useful when you have parameterized URIs (such as if we had a `/fruits/:name` URI).

For the sake of simplicity we have a simple variable cache to store Fruits. In actual applications we would be injecting storage dependencies but for this module we'll use a simple list cache.

`@GetMapping` is a special form of `@RequestMapping`. It's actually short-hand for `@RequestMapping(method = RequestMethod.GET)`. It can also take a `value` argument to specify a URI segment such as `@GetMapping("/fruits/:name")`. This `@GetMapping` will handle HTTP GET requests to the `/fruits` URI by returning a view called `index`. In Spring MVC when a `@Controller` class' method returns a String it attempts to find a view with the returned name. 

The `Model` argument to our method is a Spring MVC model. This is the glue between our Model and Spring. Spring automatically passes a Model object when it sees a Controller method with a `Model` argument. We don't have to do this ourselves. The `Model` is effectively a `Map<String, Object` which we can store data behind keys to be sent to the View. In this case we are adding two keys: `fruits` which will store the `List<Fruit>` of added fruits and `fruitForm` which is a Form Binding to our `Fruit` POJO.

>**NOTE:** The `// TODO` line will be filled in shortly. Make sure to leave this line here!

**3. Test the service from a web browser locally**

Run the application by executing the below command:

``mvn spring-boot:run``{{execute}}

>**NOTE:** The `spring-boot-crud-booster` [here](https://github.com/snowdrop/spring-boot-crud-booster) has test cases for REST that you can review if interested. 

In the interest of time, we will skip creating test cases for the service and instead test it directly in our web browser.

When the console reports that Spring is up and running access the web page by using [this link](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/fruits). The Local Browser tab will not work as it does not point to the correct URI.

While the application should come up the `Save` button should not work yet. We'll make that work next.

Press <kbd>CTRL</kbd>+<kbd>C</kbd> to stop the application.

**4. Add the POST Handler**

Now we'll add the `@PostMapping` method which will handle input from the Add Fruit form. Open ``src/main/java/com/example/service/FruitController.java``{{open}} and then copy the below content into the file at the TODO (or use the `Copy to Editor` button):

<pre class="file" data-filename="rc/main/java/com/example/service/FruitController.java" data-target="insert" data-marker="// TODO POST mapping here">
@PostMapping
    public String createFruit(@ModelAttribute Fruit fruit) {
        fruits.add(fruit);
        return "redirect:/fruits";
    }
</pre>

Now re-run the application by executing the ``mvn spring-boot:run``{{execute}} command again. When the console reports that Spring is up and running access the web page by using [this link](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/fruits).

If you add a Fruit name to the text box and click save it should now appear on the right side list.

**5. Stop the application**

Before moving on, click in the terminal window and then press <kbd>CTRL</kbd>+<kbd>C</kbd> to stop the running application!

## Congratulations

You have now learned how to how to create simple Spring MVC Controllers and how to connect your Models to the views using a Controller. In the next section we'll review the View we've created for you.