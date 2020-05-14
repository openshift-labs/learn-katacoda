In the previous step you've created a skeleton Kogito application with Quarkus and started the application in _Quarkus dev-mode_. In this step we'll create the domain model of our application.

## Facts.

A (business) rules and/or decision service operates on entities called _facts_. _Facts_ is data over which a rules engine reasons and to which it applies its constraints. In Kogito, facts are implemented as POJOs (Plain Old Java Objects).

Our _adult service_ determines if a _person_ is an adult based on his age.

From this description of our application, we can infer the _fact_:

* Person: which has a name, an age, and a boolean that states whether he/she is an adult.


## Person

We will first implement the `Person` class. To do this, we first need to create a new package in our project:

`mkdir -p /root/projects/kogito/adult-service/src/main/java/org/acme/domain`{{execute T2}}

We can now open a new `Person.java` file in this package by clicking: `adult-service/src/main/java/org/acme/domain/Person.java`{{open}}

Click on the _Copy to Editor_ link to copy the source code into the new `Person.java`file.

<pre class="file" data-filename="./adult-service/src/main/java/org/acme/domain/Person.java" data-target="replace">
package org.acme.domain;

public class Person {

    private String name;

    private int age;

    private boolean adult;

    public Person() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public boolean isAdult() {
        return adult;
    }

    public void setAdult(boolean adult) {
        this.adult = adult;
    }

}
</pre>


## Congratulations!

You've implemented the domain model of your Kogito business rules project. In the next step, we will implement the _RuleUnit_ of our application.
