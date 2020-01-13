Lets continue in this section and define are model Class

Let’s modify the application and add relevant methods. The Coffee model class has alredy been created we will add the functionality to it. 
Open a new file by clicking: `src/main/java/org/acme/reactive/Coffee.java`{{open}}.

We only have two fields, one for the ID of the Coffe and one for its name. 
<pre>

    public Long id;

    public String name;

</pre>

With this simple model we implement some of the accessor methods. e.g save, from, update etc. All of them use a PgPool object, since we are going to use a PostgreSQL database and are using the PostgreSQL reactive driver. 

Lets add the findById method.

**1. Add FindById method**
Click **Copy to Editor** to add the following code to this file:

<pre class="file" data-filename="src/main/java/org/acme/reactive/Coffee.java" data-target="insert" data-marker=" // TODO FindById">

    public static CompletionStage&lt;Coffee&gt; findById(PgPool client, Long id) {
        return client.preparedQuery("SELECT id, name FROM coffee WHERE id = $1", Tuple.of(id))
                .thenApply(RowSet::iterator)
                .thenApply(iterator -> iterator.hasNext() ? from(iterator.next()) : null);
    }

</pre>

In the above you can see we use a PgPool object and once the query is prepared we then apply the iterator. In this case the thenApply method does transformation on the fly on the Iterator that recived from the CompletableFuture and finally passing that back into the CompletionStage.

Lets move on to deploy this application

## Inspect the results

Since we still have our app running using `mvn quarkus:dev`, when you make these changes and reload the endpoint, Quarkus will notice all of these changes and live reload them.

Check that it works as expected by loading the new endpoint by [clicking here](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/).


## Congratulations!

Now you have a running app, with a reactive database extension. 
In the next step, we'll package and run it as a standalone executable JAR, which should also be familiar to microservice developers.
Now Cancel the running dev session by pressing `CTRL+C` before moving ahead.