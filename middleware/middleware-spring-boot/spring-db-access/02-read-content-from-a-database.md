# Read content from a database

In Step 1 you learned how to get started with our project. In this step, we will add functionality for our Fruit basket application to display content from the database.

**1. Adding JPA (Hibernate) to the application**

Since our application will need to access a database to retrieve and store fruit entries we need to add a Database Connection library. One such implementation in Spring is the Spring Data JPA project, which contains the Java Persistence APIs (JPA) and a JPA implementation - Hibernate. Hibernate has been tested and verified as part of the Red Hat Runtimes, so we are going to use it here. Spring Boot has full knowledge of these libraries as well so we get to take advantage of Spring Boot's auto-configuration with these libraries as well!

To add Spring Data + JPA and Hibernate to our project all we have to do is to add the following line in ``pom.xml``{{open}}

<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- TODO: Add JPA dependency here -->">
    &lt;dependency&gt;
      &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
      &lt;artifactId&gt;spring-boot-starter-data-jpa&lt;/artifactId&gt;
    &lt;/dependency&gt;
</pre>

We also need a Database to actually interact with. When running locally or when running tests an in-memory Database is often used over connection to an external Database because its lifecycle can be managed by Spring and we don't have to worry about outages impacting our local development. H2 is a small in-memory database that is perfect for testing but is not recommended for production environments. To add H2 add the following dependency at the comment `<!-- TODO: Add H2 database dependency here -->` in the local profile.

<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- TODO: Add H2 database dependency here -->">
    &lt;dependency&gt;
      &lt;groupId&gt;com.h2database&lt;/groupId&gt;
      &lt;artifactId&gt;h2&lt;/artifactId&gt;
      &lt;scope&gt;runtime&lt;/scope&gt;
    &lt;/dependency&gt;
</pre>

If Spring Boot sees a database like H2 on the classpath it will automatically configure an in-memory one for us as well as all the connection Beans necessary to connect to it. We've chosen to override these settings in the ``src/main/resources/application-local.properties``{{open}} file to demonstrate that you can interact with Spring Boot's auto-configuration quite easily. 

**2. Create an Entity class**

We are going to implement an Entity class that represents a Fruit. This class is used to map our object to a database schema.

First, we need to create the java class file. For that, you need to click on the following link which opens the skeletal class file in the editor: ``src/main/java/com/example/service/Fruit.java``{{open}}

Then, copy the below content into the file (or use the `Copy to Editor` button):

<pre class="file" data-filename="src/main/java/com/example/service/Fruit.java" data-target="replace">
package com.example.service;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Fruit {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    public Fruit() {
    }

    public Fruit(String type) {
        this.name = type;
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
}
</pre>

The `@Entity` annotation marks the object as a persistable Entity for Spring Data. The `@Id` and `@GeneratedValue` annotations are JPA annotations which mark the the `id` field as the database ID field which has an auto-generated value. Spring provides the code which makes these annotations work behind the scenes.

**3.Create a repository class for our content**

The repository should provide methods for inserting, updating, reading, and deleting Fruits from the database. We are going to use Spring Data for this which already provides us with a lot of the boilerplate code, so all we have to do is to add an interface that extends the `CrudRepository<T, I>` interface provided by Spring Data.

First, we need to fill out the skeltal java class file. For that, you need to click on the following link which opens the file in the editor: ``src/main/java/com/example/service/FruitRepository.java``{{open}}

Then, copy the below content into the file (or use the `Copy to Editor` button):

<pre class="file" data-filename="src/main/java/com/example/service/FruitRepository.java" data-target="replace">
package com.example.service;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FruitRepository extends CrudRepository&lt;Fruit, Long&gt; {
// TODO query methods
}
</pre>

**4. Populate the database with initial content**

To pre-populate the database with content, Hibernate offers a nifty feature where we can provide an SQL file that populates the content.

First, we need to create the SQL file. For that, you need to click on the following link which opens the empty file in the editor: ``src/main/resources/import.sql``{{open}}

Then, copy the below content into the file (or use the `Copy to Editor` button):

<pre class="file" data-filename="src/main/resources/import.sql" data-target="replace">
insert into fruit (name) values ('Cherry');
insert into fruit (name) values ('Apple');
insert into fruit (name) values ('Banana');
</pre>

**5. Test and Verify**
To verify that we can use the `FruitRepository` for retrieving and storing Fruit objects we have created a JUnit Test Class at ``src/test/java/com/example/service/DatabaseTest.java``{{open}}

Take a bit of time and review the tests. The `testGetAll` test will return all fruits in the repository, which should be three because of the content in `import.sql`. The `getOne` test will retrieve the fruit with ID 1 (e.g., the Cherry) and then check that it's not null. The `getWrongId` checks that if we try to retrieve a fruit id that doesn't exist and check that fruitRepository returns null.

We can now test that our `FruitRepository` can connect to the data source, retrieve data and 
Run the application by executing the below command:

``mvn verify``{{execute interrupt}}

In the console you should now see the following (if the output is too noisy the first time around because of downloads simply run the command again):

```
Results :

Tests run: 5, Failures: 0, Errors: 0, Skipped: 0
```

>**NOTE:** As a reminder: the configuration for database connectivity is found in the application properties files in `src/main/resources/` since we chose to override the Spring Boot defaults. For local we use the `application-local.properties` file. On OpenShift we use the `application-openshift.properties` file.

**6. Review The Controller**

To see how this repository could be used in a web application we're going to quickly review the FruitController file. Open ``src/main/java/com/example/service/FruitController.java``{{open}} in your editor.

In order to use our FruitRepository we must first autowire one in our constructor:

```java
public FruitController(FruitRepository repository) {
    this.repository = repository;
}
```

Since Repositories are a managed Bean in Spring we have to tell Spring to inject an instance into our Controller for use. We use Constructor Autowiring as per the suggestion of the Spring Team since it is considered best practice and allows easier mock injecting in tests.

If we are fetching all records from the database we use the aforementioned `repository.findAll()` method. To delete we have `repository.delete(id)`, to save a new entry we have `repository.save(fruit)`, and so on. All these methods reside on the CrudRepository interface which is automatically implemented by Spring.

>**NOTE:** The usual input validations have been omitted from this class for brevity's sake. Always validate and sanitize input coming from the client!

**7. Query Methods**

The methods provided by CrudRepository are nice when we are dealing directly with IDs but sometimes we don't have that information. Let's say, for example, we have a search box that allows users to search by Fruit Name. We currently do not support that functionality without using a `findAll()` and then filtering the results in the application. Not a good idea for large datasets.

Fortunately there exists within the JPA specification a section on `Query Methods`. Query methods are methods on Repositories that follow a specific naming pattern. These methods can then be turned into implementation code by JPA providers for running actual queries.

Let's re-open the FruitRepository class file in the editor: ``src/main/java/com/example/service/FruitRepository.java``{{open}} and add the following code at the TODO line (or use the `Copy to Editor` button):

<pre class="file" data-filename="src/test/java/com/example/service/FruitRepository.java" data-target="insert" data-marker="// TODO query methods">
    List&lt;Fruit&gt; findByName(String name);

    default List&lt;Fruit&gt; findAllFruitsByName(String name) {
        return findByName(name);
    }

    @Query("select f from Fruit f where f.name like %?1")
    List&lt;Fruit&gt; findByNameLike(String name);
</pre>

The first method `findByName(String name)` is a standard JPA _Query Method_. The format of this method is `findBy` followed by the field we are querying on for our Fruit object. For the `name` field we use the same name. Note that the field name is capitalized to follow the standard Java _camelCase_ format. 

The format of these methods can get pretty complex but here we're only referring to the `name` field of our `Fruit` model so the method name is pretty short. For a more in depth guide to Query Methods see [this](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#jpa.query-methods) article.

The second method demonstrates _default methods_ which were introduced in Java 8. This allows us to provide a method definition for an interface method. In this case we've created an alias for the `findByName()` method which simply delegates to the JPA Query Method. This technique is particularly useful when the Query Methods get very complex and long as it allows us to define more readable repository methods that delegate to their more complex counterpart. We can also aggregate operations in this way.

The last method is an example of the `@Query` annotation which allows you to provide an actual SQL Query to execute. Note, however, that the syntax is a little different. This is actually a dialect called JPQL which looks like ANSI SQL but with a few differences. You can, however, use native queries by adding the `nativeQuery=true` argument to the annotation. Be aware that this approach can cause tight coupling between your code and your database if you use database-specific extensions that won't be caught until runtime. This is, however, particularly useful for complex queries that are better suited for plain native SQL.

**8. Verify the application**

To verify that the application actually works now we need to actually run the application. Run the application by executing the following command ``mvn spring-boot:run``{{execute}}

Next, click on the **Local Web Browser** tab in the console frame of this browser window which will open another tab or window of your browser pointing to port 8080 on your client. Or use [this](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com) link.

You should now see an HTML page with an `Add a Fruit` textbox on the left and a `Fruits List` view on the right with the three fruits we pre-populated with the `import.sql` file. Adding a new fruit name into the textbox and clicking `Save` should insert the new Fruit name into the right-hand list. Clicking on the `Remove` buttons should also work as expected.

**9. Stop the application**

Before moving on, click in the terminal window and then press <kbd>CTRL</kbd>+<kbd>C</kbd> to stop the running application!

## Congratulations

You have now learned how to create and test a data repository that can create, read, update and delete content from a database. We have so far been testing this with an in-memory database, but later we will replace this with a full blow SQL server running on OpenShift, but first, we should create REST services that the web page can use to update content.
