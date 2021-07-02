In the previous step you created created a PostgreSQL databases for your app, and also added the extensions. In this section we will create our Reactive CoffeeResource and its endpoints.


## Add CoffeeResource endpoints

Let’s modify the application and add relevant methods. The CoffeeResource has alredy been created we will add the functionality to it.
Open a new file by clicking: `src/main/java/org/acme/reactive/CoffeeResource.java`{{open}}.

**1. Add db initialization**
Lets add a few queries to initialize our database. We could have also choosen to omit this step, in that case the database should have had these tables. But since we have a new barebones instance, we can also use this way of initializing.

Click **Copy to Editor** to add the following code to this file:

<pre class="file" data-filename="src/main/java/org/acme/reactive/CoffeeResource.java" data-target="insert" data-marker="// TODO initdb">
        client.query("DROP TABLE IF EXISTS coffee").execute()
                .flatMap(r -> client.query("CREATE TABLE coffee (id SERIAL PRIMARY KEY, name TEXT NOT NULL)").execute())
                .flatMap(r -> client.query("INSERT INTO coffee (name) VALUES ('Americano')").execute())
                .flatMap(r -> client.query("INSERT INTO coffee (name) VALUES ('Latte')").execute())
                .flatMap(r -> client.query("INSERT INTO coffee (name) VALUES ('Mocha')").execute()).await()
                .indefinitely();
</pre>

**2. Add REST methods**

First lets add our GET method so we can get the list of all the Coffee, and also if we want to look up with id where we add the `PathParam` to our method and with `@Path` annotation to enable the request to our `getSingle` method.

Click **Copy to Editor** to add the following code to this file:
<pre class="file" data-filename="src/main/java/org/acme/reactive/CoffeeResource.java" data-target="insert" data-marker="// TODO GET">

    @GET
    public Multi&lt;Coffee&gt; get() {
        return Coffee.findAll(client);
    }

    @GET
    @Path("{id}")
    public Uni&lt;Response&gt; getSingle(@PathParam("id") Long id) {
        return Coffee.findById(client, id)
            .onItem().transform(fruit -> fruit != null ? Response.ok(fruit) : Response.status(Status.NOT_FOUND))
            .onItem().transform(ResponseBuilder::build);
    }

</pre>



Next lets add the POST and PUT request methods.

Click **Copy to Editor** to add the following code to this file:
<pre class="file" data-filename="src/main/java/org/acme/reactive/CoffeeResource.java" data-target="insert" data-marker="// TODO POST">

    @POST
    public Uni&lt;Response&gt; create(Coffee coffee) {
        return coffee.save(client)
                .onItem().transform(id -> URI.create("/coffee/" + id))
                .onItem().transform(uri -> Response.created(uri).build());
    }

    @PUT
    @Path("{id}")
    public Uni&lt;Response&gt; update(@PathParam("id") Long id, Coffee coffee) {
        return coffee.update(client)
            .onItem().transform(updated -> updated ? Status.OK : Status.NOT_FOUND)
            .onItem().transform(status -> Response.status(status).build());
    }

</pre>

Finally lets add the DELETE method, so we can also delete Coffee from our quarkus app.

Click **Copy to Editor** to add the following code to this file:
<pre class="file" data-filename="src/main/java/org/acme/reactive/CoffeeResource.java" data-target="insert" data-marker="// TODO DELETE">
    @DELETE
    @Path("{id}")
    public Uni&lt;Response&gt; delete(@PathParam("id") Long id) {
        return Coffee.delete(client, id)
                .onItem().transform(deleted -> deleted ? Status.NO_CONTENT : Status.NOT_FOUND)
                .onItem().transform(status -> Response.status(status).build());
    }
</pre>

Lets continue further to add reactive accessor methods for our Coffee resource.