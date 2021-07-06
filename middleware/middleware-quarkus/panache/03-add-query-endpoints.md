In the previous step you created a basic RESTful Java application with Quarkus and a single Panache-based query. In this step we'll add a few more queries to demonstrate the ease of Panache queries vs. ordinary Hibernate/JQL queries.

## Add Queries

Let’s modify the application and add some queries. Much like traditional object-oriented programming, Panache and Quarkus recommend you place your custom entity queries as close to the entity definition as possible, in this case in the entity definition itself. Open the `Person` entity by clicking: `src/main/java/org/acme/person/model/Person.java`{{open}}.

Next, click **Copy to Editor** to add the following two new queries to this file:

<pre class="file" data-filename="./src/main/java/org/acme/person/model/Person.java" data-target="insert" data-marker="// TODO: Add more queries">
public static List&lt;Person&gt; findByColor(EyeColor color) {
        return list("eyes", color);
	}

	public static List&lt;Person&gt; getBeforeYear(int year) {
        return Person.&lt;Person&gt;streamAll()
        .filter(p -&gt; p.birth.getYear() &lt;= year)
        .collect(Collectors.toList());
	}
</pre>

These two queries will find a list of people in our database based on eye color, or birth year. Note the `getBeforeYear` is implemented using the Java Streams API.

> All list methods in Panache-based entities (those that extend from `PanacheEntity`) have equivalent stream versions. So `list` has a `stream` variant, `listAll`-->`streamAll` and so on.

With our custom entity queries implemented in our `Person` entity class, let's add RESTful endpoints to `PersonResource` to access them.

Open the `src/main/java/org/acme/person/PersonResource.java`{{open}} resource class and then click **Copy To Editor** once again to inject the new endpoints which will access our new queries:

<pre class="file" data-filename="./src/main/java/org/acme/person/PersonResource.java" data-target="insert" data-marker="// TODO: add basic queries">
@GET
    @Path("/eyes/{color}")
    @Produces(MediaType.APPLICATION_JSON)
    public List&lt;Person&gt; findByColor(@PathParam(value = "color") EyeColor color) {
        return Person.findByColor(color);
    }

    @GET
    @Path("/birth/before/{year}")
    @Produces(MediaType.APPLICATION_JSON)
    public List&lt;Person&gt; getBeforeYear(@PathParam(value = "year") int year) {
        return Person.getBeforeYear(year);
    }
</pre>

## Inspect the results

When you make these changes, Quarkus will notice all of these changes and live reload them across the remoet connection.

Check that it works as expected by testing the new endpoints. Let's find all the people with `BLUE` eyes. Execute:

`curl -s $PEOPLE_URL/person/eyes/BLUE | jq`{{execute T2}}

> This will open a new Terminal to execute the command. If the command fails to run just click the above command again!

You should only see **one** person with BLUE eyes:

```console
[
  {
    "id": 1,
    "birth": "1974-08-15",
    "eyes": "BLUE",
    "name": "Farid Ulyanov"
  }
]
```
This also confirms that our remote live coding is working as expected.

Next, let's find people born in 1990 or earlier:

`curl -s $PEOPLE_URL/person/birth/before/1990 | jq`{{execute T2}}

You should see **two** people born in 1990 or earlier:

```console
[
  {
    "id": 1,
    "birth": "1974-08-15",
    "eyes": "BLUE",
    "name": "Farid Ulyanov"
  },
  {
    "id": 2,
    "birth": "1984-05-24",
    "eyes": "BROWN",
    "name": "Salvador L. Witcher"
  }
]
```

## Congratulations!

The `Person` entity's superclass comes with lots of super useful static methods and you can add your own in your entity class. Users can just start using your entity `Person` by typing `Person`, and getting completion for all the operations in a single place.

In the next step we'll show you how Panache can help to adapt entities to high performance frontends, even in the face of millions of records. On to the next scenario!
