In the previous step you created created a PostgreSQL databases for your app, and also added the extensions. In this section we will create our Reactive CoffeResource and its endpoints.


## Add CoffeeResource endpoints

Let’s modify the application and add relevant methods. The CoffeeResource has alredy been created we will add the functionality to it. 
Open a new file by clicking: `src/main/java/org/acme/reactive/CoffeeResource.java`{{open}}.

**1. Add db initialization**
Lets add a few quireies to initialize our database. We could have also choosen to omit this step, in that case the database should have had these tables. But since we have a new barebones instance, we can also use this way of initializing. 

Click **Copy to Editor** to add the following code to this file:

<pre class="file" data-filename="src/main/java/org/acme/reactive/CoffeeResource.java" data-target="insert" data-marker="// TODO initdb">

        client.query("DROP TABLE IF EXISTS coffee")
                .thenCompose(r -> client.query("CREATE TABLE coffee (id SERIAL PRIMARY KEY, name TEXT NOT NULL)"))
                .thenCompose(r -> client.query("INSERT INTO coffee (name) VALUES ('Americano')"))
                .thenCompose(r -> client.query("INSERT INTO coffee (name) VALUES ('Latte')"))
                .thenCompose(r -> client.query("INSERT INTO coffee (name) VALUES ('Mocha')"))
                .toCompletableFuture()
                .join();

</pre>

**2. Add REST methods**

First lets add our GET method so we can get the list of all the Coffee, and also if we want to look up with id where we add the PathParam to our method and with @Path annotation to enable the request to our getSingle method.

Click **Copy to Editor** to add the following code to this file:
<pre class="file" data-filename="src/main/java/org/acme/reactive/CoffeeResource.java" data-target="insert" data-marker="// TODO GET">

   @GET
    public CompletionStage<Response> get() {
        return Coffee.findAll(client)
                .thenApply(Response::ok)
                .thenApply(ResponseBuilder::build);
    }

    @GET
    @Path("{id}")
    public CompletionStage&lt;Response&gt; getSingle(@PathParam Long id) {
        return Coffee.findById(client, id)
                .thenApply(coffee -> coffee != null ? Response.ok(coffee) : Response.status(Status.NOT_FOUND))
                .thenApply(ResponseBuilder::build);
    }

</pre>



Next lets add the POST and PUT request methods. 

Click **Copy to Editor** to add the following code to this file:
<pre class="file" data-filename="src/main/java/org/acme/reactive/CoffeeResource.java" data-target="insert" data-marker="// TODO POST">

    @POST
    public CompletionStage<Response> create(Coffee coffee) {
        return coffee.save(client)
                .thenApply(id -> URI.create("/coffee/" + id))
                .thenApply(uri -> Response.created(uri).build());
    }

    @PUT
    @Path("{id}")
    public CompletionStage<Response> update(@PathParam Long id, Coffee coffee) {
        return coffee.update(client)
                .thenApply(updated -> updated ? Status.OK : Status.NOT_FOUND)
                .thenApply(status -> Response.status(status).build());
    }

</pre>

Finally lets add the DELETE method, so we can also delete Coffee from our quarkus app.

Click **Copy to Editor** to add the following code to this file:
<pre class="file" data-filename="src/main/java/org/acme/reactive/CoffeeResource.java" data-target="insert" data-marker="// TODO DELETE">

    @DELETE
    @Path("{id}")
    public CompletionStage<Response> delete(@PathParam Long id) {
        return Coffee.delete(client, id)
                .thenApply(deleted -> deleted ? Status.NO_CONTENT : Status.NOT_FOUND)
                .thenApply(status -> Response.status(status).build());
    }

</pre>


**2. Inspect the application.properties**
Lets take a final look at our application.properties file, which has been prepared. 

Once generated, look at the `src/main/resources/application.properties`{{open}}

The file should look similar to the following
<pre class="file">
# Configuration file
# key = value
quarkus.datasource.url=vertx-reactive:postgresql://database.default.svc:5432/sampledb
quarkus.datasource.username=username
quarkus.datasource.password=password
</pre>

Notice that the name of the service is `database.default.svc` this is an internal project/namespace name, the database is not exposed on the outside network. And our application will be in the same project namespace hence we will be able to connect to it.
If you want to read more about Openshift projects and name spaces you can do it here: [Openshift Docs](https://docs.openshift.com/enterprise/3.0/architecture/core_concepts/projects_and_users.html)

Lets continue further.