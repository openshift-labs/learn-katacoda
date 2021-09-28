# Create Spring Data Repository

The Spring Data repository abstraction simplifies dealing with data models by reducing the amount of boilerplate code required to implement data access layers for various persistence stores (such as JPA). `@Repository` and its sub-interfaces like `@CrudRepository` are the [central concept in Spring Data](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#repositories.core-concepts) which is a marker interface to provide data manipulation functionality for the entity class that is being managed. When the application starts, Quarkus configures the required persistence technologies and provides an implementation for the interfaces used.

First, we need a data model.

## Create Model

Click here to create and open a new file for our Remodelpository: `fruit-taster/src/main/java/org/acme/Fruit.java`{{open}}.

Click **Copy to Editor** to add the code:

<pre class="file" data-filename="./fruit-taster/src/main/java/org/acme/Fruit.java" data-target="replace">
package org.acme;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class Fruit {

    @Id
    @GeneratedValue
    private Long id;

    private String name;

    private String color;


    public Fruit() {
    }

    public Fruit(String name, String color) {
        this.name = name;
        this.color = color;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }
}
</pre>

This is a simple POJO representing a Fruit, with a name and color.

## Create Spring Data Repository

Next, click here to create and open a new file for our Repository: `fruit-taster/src/main/java/org/acme/FruitRepository.java`{{open}}.

Click **Copy to Editor** to create the code for the repository:

<pre class="file" data-filename="./fruit-taster/src/main/java/org/acme/FruitRepository.java" data-target="replace">
package org.acme;

import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface FruitRepository extends CrudRepository&lt;Fruit, Long&gt; {

    List&lt;Fruit&gt; findByColor(String color);

}
</pre>

Note that by extending Spring's `CrudRepository` interface you'll automatically get a complete set of methods to manipulate the entity (e.g. `count()`, `findAll()`, `delete()` and others).

## Create sample data

Finally, we need some sample data to work with. Click here to create and open a new file to hold our sample data: `fruit-taster/src/main/resources/import.sql`{{open}}.

Click **Copy to Editor** to create add the sample data which will be used to populate our database when the app runs:

<pre class="file" data-filename="./fruit-taster/src/main/resources/import.sql" data-target="replace">
INSERT INTO fruit(id, name, color) VALUES (nextval('hibernate_sequence'), 'cherry', 'red');
INSERT INTO fruit(id, name, color) VALUES (nextval('hibernate_sequence'), 'orange', 'orange');
INSERT INTO fruit(id, name, color) VALUES (nextval('hibernate_sequence'), 'banana', 'yellow');
INSERT INTO fruit(id, name, color) VALUES (nextval('hibernate_sequence'), 'avocado', 'green');
INSERT INTO fruit(id, name, color) VALUES (nextval('hibernate_sequence'), 'strawberry', 'red');
</pre>

## Configure Quarkus

We need to configure our app to define database connection settings. Click: `fruit-taster/src/main/resources/application.properties`{{open}} to open this file. This file contains Quarkus configuration.

Click **Copy to Editor** to add the following values to the `application.properties` file:

<pre class="file" data-filename="./fruit-taster/src/main/resources/application.properties" data-target="replace">
quarkus.datasource.db-kind=h2
quarkus.datasource.jdbc.url=jdbc:h2:mem:rest-crud
quarkus.hibernate-orm.database.generation=drop-and-create
quarkus.hibernate-orm.log.sql=true
quarkus.hibernate-orm.sql-load-script=import.sql
</pre>

That’s it! Now you have a database, domain model (`Fruit`) and a repository (`FruitRepository`) to retrieve the domain model, and some sample data.

> **NOTE**
> Although we are using `import.sql` to initialize our database in our app, you shouldn't use this in production. Instead, review [suggested uses of Hibernate ORM in production](https://quarkus.io/guides/hibernate-orm#hibernate-orm-in-production-mode).

Next, we'll create some injectable Spring Beans that will give us access to the data using the Spring DI annotations.