Lets continue in this section and define are model Class

Let’s modify the application and add relevant methods. The `Coffee` model class has alredy been created we will add the functionality to it.
Open a new file by clicking: `src/main/java/org/acme/reactive/Coffee.java`{{open}}.

We only have two fields, one for the ID of the Coffe and one for its name.
<pre>

    public Long id;

    public String name;

</pre>

With this simple model we implement some of the accessor methods. e.g save, from, update etc. All of them use a `PgPool` object, since we are going to use a PostgreSQL database and are using the PostgreSQL reactive driver.

Lets add the `findById` method.

**1. Add FindById method**
Click **Copy to Editor** to add the following code to this file:

<pre class="file" data-filename="src/main/java/org/acme/reactive/Coffee.java" data-target="insert" data-marker=" // TODO FindById">

    public static Uni&lt;Coffee&gt; findById(PgPool client, Long id) {
        return client.preparedQuery("SELECT id, name FROM coffee WHERE id = $1").execute(Tuple.of(id))
                .onItem().transform(RowSet::iterator)
                .onItem().transform(iterator -> iterator.hasNext() ? from(iterator.next()) : null);
    }

</pre>

In the above you can see we use a `PgPool` object and once the query is prepared we then apply successive `onItem` reactive methods to transform the result and finally passing that back as a `Uni<Coffee>`, part of the Mutiny reactive API.

## Inspect the results

Since we still have our app running and connected remotely using Quarkus' remote development, when you make these changes and reload the endpoint, Quarkus will notice all of these changes and live reload them on the remote side.

Check that it works as expected by revisiting the page by [clicking here](http://reactive-sql-reactive-sql.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com).

Try to add and remove Coffee elements to the list.

## Congratulations!

Now you have a running app, with a reactive database extension.
In the next step, we'll redeploy it to OpenShift.

Now Cancel the running dev session by clicking the `clear`{{execute T1 interrupt}} before moving ahead.