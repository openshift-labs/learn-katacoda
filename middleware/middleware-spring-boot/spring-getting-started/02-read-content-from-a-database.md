# Read content from a database

In Step 1 you learned how to get started with our project. In this step, we will add functionality for our Fruit basket application to display content from the database.

**1. Adding JPA (Hibernate) to the application**

Since our applications (like most) will need to access a database to read retrieve and store fruits entries, we need to add Java Persistence API to our project. 

The default implementation is Spring Boot is Hibernate, and that has also been tested and verified as part of the OpenShift Application Runtimes.

>**NOTE:** Hibernate is another Open Source project that is maintained by Red Hat and it will soon be productized (as in fully supported) in OpenShift Application Runtimes. 

To add Hibernate to our project all we have to do is to add the following line in ``pom.xml``{{open}}

<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- TODO: Add JPA dependency here -->">
    &lt;dependency&gt;
      &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
      &lt;artifactId&gt;spring-boot-starter-data-jpa&lt;/artifactId&gt;
    &lt;/dependency&gt;
</pre>

When testing starting locally or when running test we also need to use a local database. H2 is a small in-memory database that is perfect for testing but is not recommended for production environments. To add H2 add the following dependency at the comment `<!-- TODO: ADD H2 database dependency here -->` in the local profile.

<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- TODO: ADD H2 database dependency here -->">
        &lt;dependency&gt;
          &lt;groupId&gt;com.h2database&lt;/groupId&gt;
          &lt;artifactId&gt;h2&lt;/artifactId&gt;
          &lt;scope&gt;runtime&lt;/scope&gt;
        &lt;/dependency&gt;</pre>


**2. Create an Entity class**

We are going to implement an Entity class that represents a fruit. This class is used to map our object to a database schema.

First, we need to create the java class file. For that, you need to click on the following link, which open the empty file in the editor: ``src/main/java/com/example/service/Fruit.java``{{open}}

Then, copy the below content into the file (or use the `Copy to editor` button):

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
    private Integer id;

    private String name;

    public Fruit() {
    }

    public Fruit(String type) {
        this.name = type;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
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


 **3.Create a repository class for our content**

The repository should provide with methods for insert, update, select and delete Fruits from the database. We are going to use Spring Data for this which already provides us with a lot of the boilerplate code, so all we have to do is to add an interface that extends the `CrudRepository<Fruit, Integer>` interface provided by Spring Data.

First, we need to create the java class file. For that, you need to click on the following link, which open the empty file in the editor: ``src/main/java/com/example/service/FruitRepository.java``{{open}}

Then, copy the below content into the file (or use the `Copy to editor` button):

<pre class="file" data-filename="src/main/java/com/example/service/FruitRepository.java" data-target="replace">
package com.example.service;

import org.springframework.data.repository.CrudRepository;

public interface FruitRepository extends CrudRepository&lt;Fruit, Integer&gt; {
}
</pre>

**4. Populate the database with initial content**

To pre-populate the database with content, Hibernate offers a nifty feature where we can provide an SQL file that populates the content.

First, we need to create the SQL  file. For that, you need to click on the following link, which open the empty file in the editor: ``src/main/resources/import.sql``{{open}}

Then, copy the below content into the file (or use the `Copy to editor` button):

<pre class="file" data-filename="src/main/resources/import.sql" data-target="replace">
insert into fruit (name) values ('Cherry');
insert into fruit (name) values ('Apple');
insert into fruit (name) values ('Banana');
</pre>

**5. Add a test class**
To verifies that we can use the `FruitRepository` for retrieving and storing Fruit objects, we are going to create a test class.

First, we need to create the java class file. For that, you need to click on the following link, which open the empty file in the editor: ``src/test/java/com/example/ApplicationTest.java``{{open}}

Then, copy the below content into the file (or use the `Copy to editor` button):

<pre class="file" data-filename="src/test/java/com/example/ApplicationTest.java" data-target="replace">
package com.example;

import java.util.Collections;

import com.example.service.Fruit;
import com.example.service.FruitRepository;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class ApplicationTest {

    @Autowired
    private FruitRepository fruitRepository;

    @Before
    public void beforeTest() {
    }

    @Test
    public void testGetAll() {
      assertTrue(fruitRepository.findAll().spliterator().getExactSizeIfKnown()==3);
    }
    
    @Test
    public void getOne() {
      assertTrue(fruitRepository.findOne(1)!=null);
    }

    @Test
    public void updateAFruit() {
        Fruit apple = fruitRepository.findOne(2);
        assertTrue(apple!=null);
        assertTrue(apple.getName().equals("Apple"));
        
        apple.setName("Green Apple");
        fruitRepository.save(apple);
        
        assertTrue(fruitRepository.findOne(2).getName().equals("Green Apple"));
    }

    @Test
    public void createAndDeleteAFruit() {
        int orangeId = fruitRepository.save(new Fruit("Orange")).getId();
        Fruit orange = fruitRepository.findOne(orangeId);
        assertTrue(orange!=null);
        fruitRepository.delete(orange);
        assertTrue(fruitRepository.findOne(orangeId)==null);
    }

    @Test
    public void getWrongId() {
      assertTrue(fruitRepository.findOne(9999)==null);
    }
}
</pre>

Take a bit of time and review the tests. The `testGetAll` test will return all fruits in the repository, which should be three because of what the content in `import.sql`. The `getOne` test will retrieve the fruit with id 1 (e.g., the Cherry) and then check that it's not null. The `getWrongId` check that if we try to retrieve a fruit id that doesn't exist and check that fruitRepository return null.

**5. Run and verify**

We can now test that our `FruitRepository` can connect to the data source, retrieve data and 
Run the application by executing the below command:

``mvn verify``{{execute}}

In the console you should now see the following:

```
Results :

Tests run: 5, Failures: 0, Errors: 0, Skipped: 0
```


## Congratulations

You have now learned how to create and test a data repository that can create, read, update and delete content from a database. We have so far been testing this with an in-memory database, but later we will replace this with a full blow SQL server running on OpenShift, but first, we should create REST services that the web page can use to update content.
