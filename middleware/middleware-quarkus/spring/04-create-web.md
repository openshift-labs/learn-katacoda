# Using Spring Web Annotations in Quarkus

While you are encouraged to use JAX-RS annotation for defining REST endpoints, Quarkus provides a compatibility layer for Spring Web in the form of the `spring-web` extension.

This step shows how your Quarkus application can leverage the well known Spring Web annotations to define RESTful services.

## Create Controllers

Click here to create and open a new file for our basic controller for accessing Fruits: `fruit-taster/src/main/java/org/acme/FruitController.java`{{open}}.

Click **Copy to Editor** to create the code for the controller:

<pre class="file" data-filename="./fruit-taster/src/main/java/org/acme/FruitController.java" data-target="replace">
package org.acme;

import java.util.List;
import java.util.Optional;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;

@RestController
@RequestMapping("/fruits")
public class FruitController {

    private final FruitRepository fruitRepository;

    public FruitController(FruitRepository fruitRepository) {
        this.fruitRepository = fruitRepository;
    }

    @GetMapping(produces = "application/json")
    public Iterable&lt;Fruit&gt; findAll() {
        return fruitRepository.findAll();
    }


    @DeleteMapping("/{id}")
    public void delete(@PathVariable(name = "id") long id) {
        fruitRepository.deleteById(id);
    }

    @PostMapping(path = "/name/{name}/color/{color}", produces = "application/json")
    public Fruit create(@PathVariable(name = "name") String name, @PathVariable(name = "color") String color) {
        return fruitRepository.save(new Fruit(name, color));
    }

    @PutMapping(path = "/id/{id}/color/{color}", produces = "application/json")
    public Fruit changeColor(@PathVariable(name = "id") Long id, @PathVariable(name = "color") String color) {
        Optional&lt;Fruit&gt; optional = fruitRepository.findById(id);
        if (optional.isPresent()) {
            Fruit fruit = optional.get();
            fruit.setColor(color);
            return fruitRepository.save(fruit);
        }

        throw new IllegalArgumentException("No Fruit with id " + id + " exists");
    }

    @GetMapping(path = "/color/{color}", produces = "application/json")
    public List&lt;Fruit&gt; findByColor(@PathVariable(name = "color") String color) {
        return fruitRepository.findByColor(color);
    }
}
</pre>

Notice the use of familiar Spring annotations like `@GetMapping` and `@PathVariable`. This exposes a set of RESTful APIs:

* `GET /fruits` - Retrieve all Fruits as a JSON array
* `DELETE /fruits/{id}` - Delete by ID
* `POST /fruits/name/{name}/color/{color}` - create a new Fruit with a name and color
* `PUT /fruits/id/{id}/color/{color}` - Update a fruit with a new color
* `GET /fruits/color/{color}` - Retrieve all fruits of the specified color

# Test app

With this in place, we can now test our fruits access. The app is still running, so simply click the following commands to do a few operations:

Get all fruits:

`curl -s http://localhost:8080/fruits | jq`{{execute T2}}

> Note you may need to click the command again, if it didn't execute in the new Terminal window.
> **If you get a `parse error:`**, it is likely you missed an earlier step, and the Quarkus live reload caught it. Click on the [app's landing page](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com)
> to see details and clues about what may be wrong, and re-visit any prior steps to re-add the missing code.

> Note that we pass the output to the `jq` utility which prints nicely-formatted JSON.

You should see:

```json
[
  {
    "color": "red",
    "id": 1,
    "name": "cherry"
  },
  {
    "color": "orange",
    "id": 2,
    "name": "orange"
  },
  {
    "color": "yellow",
    "id": 3,
    "name": "banana"
  },
  {
    "color": "green",
    "id": 4,
    "name": "avocado"
  },
  {
    "color": "red",
    "id": 5,
    "name": "strawberry"
  }
]
```

Add a fruit:

`curl -X POST -s http://localhost:8080/fruits/name/apple/color/red | jq`{{execute T2}}

Get all `red` fruits:

`curl -s http://localhost:8080/fruits/color/red | jq`{{execute T2}}

Notice the presence of `apple` which we just added earlier.

Change the color of the `apple` to `green`:

`curl -X PUT -s http://localhost:8080/fruits/id/6/color/green | jq`{{execute T2}}

And retrieve all green fruits:

`curl -s curl -s http://localhost:8080/fruits/color/green | jq`{{execute T2}}

You should see:

```json
[
  {
    "color": "green",
    "id": 4,
    "name": "avocado"
  },
  {
    "color": "green",
    "id": 6,
    "name": "apple"
  }
]
```

Indicating that the color of our `apple` has changed to `green`.

## Exercise Beans using Spring DI Annotations

As a final test let's create another bean to use our injected beans and configuration using Spring DI annotations.

Click here to create and open a new file for our taster controller for tasting Fruits: `fruit-taster/src/main/java/org/acme/TasterController.java`{{open}}.

Click **Copy to Editor** to create the code for the controller:

<pre class="file" data-filename="./fruit-taster/src/main/java/org/acme/TasterController.java" data-target="replace">
package org.acme;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import org.springframework.web.bind.annotation.PathVariable;

@RestController
@RequestMapping("/taster")
public class TasterController {

    private final FruitRepository fruitRepository;

    private final TasterBean tasterBean;

    public TasterController(FruitRepository fruitRepository, TasterBean tasterBean) {
        this.fruitRepository = fruitRepository;
        this.tasterBean = tasterBean;
    }

    @GetMapping(produces = "application/json")
    public List&lt;TasteResult&gt; tasteAll() {
        List&lt;TasteResult&gt; result = new ArrayList<>();

        fruitRepository.findAll().forEach(fruit -> {
            result.add(new TasteResult(fruit, tasterBean.taste(fruit.getName())));
        });
        return result;
    }

    @GetMapping(path = "/{color}", produces = "application/json")
    public List&lt;TasteResult&gt; tasteByColor(@PathVariable(name = "color") String color) {
        List&lt;TasteResult&gt; result = new ArrayList<>();
        fruitRepository.findByColor(color).forEach(fruit -> {
            result.add(new TasteResult(fruit, tasterBean.taste(fruit.getName())));
        });
        return result;
    }

    public class TasteResult {
        public Fruit fruit;
        public String result;

        public TasteResult(Fruit fruit, String result) {
            this.fruit = fruit;
            this.result = result;
        }

    }
}
</pre>

Again, we're using Spring Rest annotations like `@GetMapping` but we're also injecting our repository and taster bean in the constructor. This controller exposes 2 RESTful APIs:

* `GET /taster` - taste all fruits and report result
* `GET /taster/{color}` - Taste only fruits of the specified color

App still running? Check. Let's test our new API:

Taste all the fruits:

`curl -s http://localhost:8080/taster | jq`{{execute T2}}

You should see:

```json
[
  {
    "fruit": {
      "color": "red",
      "id": 1,
      "name": "cherry"
    },
    "result": "CHERRY: TASTES GREAT !"
  },
  {
    "fruit": {
      "color": "orange",
      "id": 2,
      "name": "orange"
    },
    "result": "ORANGE: TASTES GREAT !"
  },
  {
    "fruit": {
      "color": "yellow",
      "id": 3,
      "name": "banana"
    },
    "result": "BANANA: TASTES GREAT !"
  },
  {
    "fruit": {
      "color": "green",
      "id": 4,
      "name": "avocado"
    },
    "result": "AVOCADO: TASTES GREAT !"
  },
  {
    "fruit": {
      "color": "red",
      "id": 5,
      "name": "strawberry"
    },
    "result": "STRAWBERRY: TASTES GREAT !"
  }
]
```
Taste only the `green` fruits:

`curl -s http://localhost:8080/taster/green | jq`{{execute T2}}

```
[
  {
    "fruit": {
      "color": "green",
      "id": 4,
      "name": "avocado"
    },
    "result": "AVOCADO: TASTES GREAT !"
  }
]
```

## Add a suffix

Click **Copy to Editor** to add a new suffix for our taster:

<pre class="file" data-filename="./fruit-taster/src/main/resources/application.properties" data-target="append">
taste.suffix = (if you like fruit!)
</pre>

And taste yellow fruits:

`curl -s http://localhost:8080/taster/yellow | jq`{{execute T2}}

You should see:

```json
[
  {
    "fruit": {
      "color": "yellow",
      "id": 3,
      "name": "banana"
    },
    "result": "BANANA: TASTES GREAT (IF YOU LIKE FRUIT!)"
  }
]
```

Notice the presence of our new suffix! Quarkus apps make it super easy to code, test, and re-code on the fly.

## Cleanup

We're done coding, so let's stop the app. In the first Terminal, press `CTRL-C` to stop the running Quarkus app (or click the `clear`{{execute T1 interrupt}} command to do it for you).

