# Read content from a database

In Step 1 you learned how to get started with our project. In this step, we will add functionality for our Fruit basket application to display content from the database.

**1. Adding JPA (Hibernate) to the application**

Since our applications (like most) will need to access a database to read retrieve and store fruits entries, we need to add Java Persistence API to our project. 

The default implementation in Spring Boot is Hibernate which has been tested as part of the Red Hat Runtimes.

>**NOTE:** Hibernate is another Open Source project that is maintained by Red Hat and it will soon be productized (as in fully supported) in Red Hat Runtimes. 

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

The repository should provide methods for insert, update, select and delete operations on Fruits from the database. We use Spring Data which provides us with lots of boilerplate code. All we have to do is to add an interface that extends the `CrudRepository<Fruit, Integer>` interface provided by Spring Data.

First, we need to create the java class file. For that, you need to click on the following link, which open the empty file in the editor: ``src/main/java/com/example/service/FruitRepository.java``{{open}}

Then, copy the below content into the file (or use the `Copy to editor` button):

<pre class="file" data-filename="src/main/java/com/example/service/FruitRepository.java" data-target="replace">
package com.example.service;

import org.springframework.data.repository.CrudRepository;

public interface FruitRepository extends CrudRepository&lt;Fruit, Integer&gt; {
}
</pre>

**4. Populate the database with initial content**

To pre-populate the database with content, Hibernate offers a nifty feature where we can provide a SQL file that populates the content.

First, we need to create the SQL  file. For that, you need to click on the following link, which open the empty file in the editor: ``src/main/resources/import.sql``{{open}}

Then, copy the below content into the file (or use the `Copy to editor` button):

<pre class="file" data-filename="src/main/resources/import.sql" data-target="replace">
insert into fruit (name) values ('Cherry');
insert into fruit (name) values ('Apple');
insert into fruit (name) values ('Banana');
</pre>

**5. Add a test class**
Verify that we can use the `FruitRepository` for retrieving and storing Fruit objects by creating a test class.

First, we need to create the java class file. Click on the following link to open an empty file in the editor: ``src/test/java/com/example/ApplicationTest.java``{{open}}

Then, copy the below content into the file (or use the `Copy to editor` button):

<pre class="file" data-filename="src/test/java/com/example/ApplicationTest.java" data-target="replace">
package com.example;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.Optional;

import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.example.service.Fruit;
import com.example.service.FruitRepository;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Transactional
public class ApplicationTest {

    @Autowired
    private FruitRepository fruitRepository;

    @Test
    public void testGetAll() {
        assertThat(this.fruitRepository.findAll())
          .isNotNull()
          .hasSize(3);
    }

    @Test
    public void getOne() {
        assertThat(this.fruitRepository.findById(1))
          .isNotNull()
          .isPresent();
    }

    @Test
    public void updateAFruit() {
        Optional&lt;Fruit&gt; apple = this.fruitRepository.findById(2);

        assertThat(apple)
          .isNotNull()
          .isPresent()
          .get()
          .extracting(Fruit::getName)
          .isEqualTo("Apple");

        Fruit theApple = apple.get();
        theApple.setName("Green Apple");
        this.fruitRepository.save(theApple);

        assertThat(this.fruitRepository.findById(2))
          .isNotNull()
          .isPresent()
          .get()
          .extracting(Fruit::getName)
          .isEqualTo("Green Apple");
    }

    @Test
    public void createAndDeleteAFruit() {
        int orangeId = this.fruitRepository.save(new Fruit("Orange")).getId();
        Optional&lt;Fruit&gt; orange = this.fruitRepository.findById(orangeId);
        assertThat(orange)
          .isNotNull()
          .isPresent();

        this.fruitRepository.delete(orange.get());

        assertThat(this.fruitRepository.findById(orangeId))
          .isNotNull()
          .isNotPresent();
    }

    @Test
    public void getWrongId() {
        assertThat(this.fruitRepository.findById(9999))
          .isNotNull()
          .isNotPresent();
    }
}

</pre>

Take some time to review the tests. The `testGetAll` test returns all fruits in the repository, which should be three because of what the content in `import.sql`. The `getOne` test will retrieve the fruit with id 1 (e.g., the Cherry) and then check that it's not null. The `getWrongId` check that if we try to retrieve a fruit id that doesn't exist and check that fruitRepository return null.

**6. Run and verify**

We can now test that our `FruitRepository` can connect to the data source, retrieve data and 
Run the application by executing the below command:

``mvn verify``{{execute interrupt}}

In the console you should now see the following:

```
Results :

Tests run: 5, Failures: 0, Errors: 0, Skipped: 0
```


## Congratulations

You have learned how to create and test a data repository that can create, read, update and delete content from a database. We have been testing this with an in-memory database, but later we will replace this with a full blow SQL server running on OpenShift, but first, we should create REST services that the web page can use to update content.
