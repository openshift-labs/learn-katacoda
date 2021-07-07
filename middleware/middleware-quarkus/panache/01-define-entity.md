In this step, you will start with a simple RESTful application generated from the Quarkus tooling, and then define a new entity to work on, which will be persisted in a typical database through JDBC.

# Inspect Java runtime

An appropriate Java runtime has been installed for you. Ensure you can use it by running this command:

> If the command fails, wait a few moments and try again (it is installed in a background process and make take a few moments depending on system load).

`$JAVA_HOME/bin/java --version`{{execute}}

The command should report the version in use, for example (the versions and dates may be slightly different than the below example):

```console
openjdk 11.0.10 2021-01-19
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.10+9)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 11.0.10+9, mixed mode)
```

## Import the code

Let's refresh the code we'll be using. Run the following command to clone the sample project:

`cd /root/projects && rm -rf rhoar-getting-started && git clone https://github.com/openshift-katacoda/rhoar-getting-started`{{execute}}

# Inspect project

Make sure you're in the right project directory by clicking:

`cd /root/projects/rhoar-getting-started/quarkus/panache`{{execute}}

Initially, the project is almost empty and doesn't do anything. Start by reviewing the content by executing a `tree`{{execute}} in your terminal.

As you can see, there are some files that we have prepared for you in the project. Under `src/main/resources/META-INF/resources` we have for example prepared an html file for you, and some skeletal model files and utilities. This matches what you might get when generating sample projects [using the Quarkus Project Generator](https://code.quarkus.io).

We need to add a few extensions to the app for Panache and Postgres. We'll use the Quarkus Maven Plugin.

Click this command to add the Hibernate ORM with Panache and PostgreSQL JDBC extensions:

`mvn quarkus:add-extension -Dextensions="hibernate-orm-panache, jdbc-postgresql"`{{execute}}

You should see:

```console
[SUCCESS] ✅ Extension io.quarkus:quarkus-hibernate-orm-panache has been installed
[SUCCESS] ✅ Extension io.quarkus:quarkus-jdbc-postgresql has been installed
```

Done!

> There are [many more extensions](https://quarkus.io/extensions/) for Quarkus for popular frameworks like [Eclipse Vert.x](https://vertx.io), [Apache Camel](http://camel.apache.org/), [Infinispan](http://infinispan.org/), Spring DI compatibility (e.g. `@Autowired`), and more.

For more detail on basic Quarkus usage, check out the [Getting Started](https://learn.openshift.com/middleware/courses/middleware-quarkus/getting-started) scenario. We'll assume you've worked through that and understand the basics of a Quarkus app.

# Define the entity

This app will be a database of people, each of which have a name, birthdate, and eye color. We'll need an entity, so open up the `src/main/java/org/acme/person/model/Person.java`{{open}} file, and add the following entity definition:

<pre class="file" data-filename="./src/main/java/org/acme/person/model/Person.java" data-target="replace">
package org.acme.person.model;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;

import io.quarkus.hibernate.orm.panache.PanacheEntity;

@Entity
public class Person extends PanacheEntity {
    // the person's name
    public String name;

    // the person's birthdate
    public LocalDate birth;

    // the person's eye color
    @Enumerated(EnumType.STRING)
    @Column(length = 8)
    public EyeColor eyes;

    // TODO: Add more queries
}
</pre>

> You'll see a `// TODO` line - **do not delete it!** We will use this later on.

As you can see we've defined the three fields `name`, `birth`, and `eyes`. We're using the Java Persistence API's `@Enumerated` field type for our eye color.

We'll also need the definition of eye colors, so let's create an `enum`. Open up the `src/main/java/org/acme/person/model/EyeColor.java`{{open}} file, and add the following enum definition:

<pre class="file" data-filename="./src/main/java/org/acme/person/model/EyeColor.java" data-target="replace">
package org.acme.person.model;

public enum EyeColor {
    BLUE, GREEN, HAZEL, BROWN
}
</pre>

# Define the RESTful endpoint

Next, we'll create a `PersonResource` class which we will use for our RESTful endpoint. Open up that file by clicking: `src/main/java/org/acme/person/PersonResource.java`{{open}} and click **Copy To Editor** to add its code:

<pre class="file" data-filename="./src/main/java/org/acme/person/PersonResource.java" data-target="replace">
package org.acme.person;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

import javax.enterprise.event.Observes;
import javax.transaction.Transactional;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import org.acme.person.model.DataTable;
import org.acme.person.model.EyeColor;
import org.acme.person.model.Person;

import io.smallrye.common.annotation.Blocking;
import io.quarkus.panache.common.Parameters;
import io.quarkus.runtime.StartupEvent;
import io.quarkus.hibernate.orm.panache.PanacheQuery;

@Path("/person")
@Blocking
public class PersonResource {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List&lt;Person&gt; getAll() {
        return Person.listAll();
    }

    // TODO: add basic queries

    // TODO: add datatable query

    // TODO: Add lifecycle hook

}
</pre>

> You'll see a lot of `// TODO` lines - **do not delete them!** We will use these later on.

As you can see we've implemented our first Panache-based query, the `getAll` method, which will return our list of people as a JSON object when we access the `GET /person` endpoint. This is defined using standard JAX-RS `@Path` and `@GET` and `@Produces` annotations.

# Add sample data

Let's add some sample data to the database so we can test things out. Open up the `src/main/resources/import.sql`{{open}} file and click to add some SQL statements to run on startup:

<pre class="file" data-filename="./src/main/resources/import.sql" data-target="replace">
INSERT INTO person(id, name, birth, eyes) VALUES (nextval('hibernate_sequence'), 'Farid Ulyanov', to_date('1974-08-15', 'YYYY-MM-dd'), 'BLUE');
INSERT INTO person(id, name, birth, eyes) VALUES (nextval('hibernate_sequence'), 'Salvador L. Witcher', to_date('1984-05-24', 'YYYY-MM-dd'), 'BROWN');
INSERT INTO person(id, name, birth, eyes) VALUES (nextval('hibernate_sequence'), 'Huỳnh Kim Huê', to_date('1999-04-25', 'YYYY-MM-dd'), 'HAZEL');
</pre>

These statements will add some fake people to our database.

