**1. What is Java Persistence API?**

The Java Persistence API (JPA) is a Java application programming interface specification that describes the management of relational data in applications using Java Platform. Java Persistence API removes a lot of boilerplate code and helps bridge the differences between the object modules (used in Object-oriented languages like Java) and the relational model (used in relational databases like PostgreSQL®, MySQL®, Oracle® DB, etc.). JPA is commonly used in both Jakarta EE and other frameworks like Spring Data.

The JPA implementation in JBoss EAP is called Hibernate, which is a Red Hat-lead open source project. Hibernate is probably the most popular JPA implementation known for its stability and performance.

**2. Enable JPA in JBoss EAP**
Jakarta EE has sometimes received criticism for being too big, making application servers slow and requiring too much resources, but to be fair Jakarta EE is only a specification of different API's and how they should work. How these specifications are implemented are left to the application server, and while there are application servers that are slow and requires a lot of resources, JBoss EAP is a modern application server based on a modular architecture using subsystems to implement Jakarta EE technologies. Many of these modules are only started when an application makes uses of them. So  if you are only using parts of all the features in Jakarta EE, JBoss EAP will not waste resources like memory and CPU with unused subsystems.

The way you enable JPA in JBoss EAP merely is by putting a `persistence.xml` file on the classpath. The `persistence.xml` file is anyway required by the JPA specification and holds the base configuration, for example, which datasource to use.

Our first step is to create a `persistence.xml` file in `src/main/resources/META-INF`.

Click this link to create and open the file `src/main/resources/META-INF/persistence.xml`{{open}}

Next, Click on **Copy To Editor** below to add the content to the file.

<pre class="file" data-filename="./src/main/resources/META-INF/persistence.xml" data-target="replace">
&lt;?xml version="1.0" encoding="UTF-8"?&gt;

&lt;persistence version="2.1"
             xmlns="http://xmlns.jcp.org/xml/ns/persistence" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="
        http://xmlns.jcp.org/xml/ns/persistence
        http://xmlns.jcp.org/xml/ns/persistence/persistence_2_1.xsd"&gt;
    &lt;persistence-unit name="primary"&gt;
        &lt;jta-data-source&gt;java:jboss/datasources/WeatherDS&lt;/jta-data-source&gt;
        &lt;properties&gt;
            &lt;!-- Properties for Hibernate --&gt;
            &lt;property name="hibernate.hbm2ddl.auto" value="create-drop" /&gt;
            &lt;property name="hibernate.show_sql" value="true" /&gt;
        &lt;/properties&gt;
    &lt;/persistence-unit&gt;
&lt;/persistence&gt;
</pre>

Note that we are giving the persistence unit the name `primary` and instructing it to use the JTA datasource called `java:jboss/datasources/WeatherDS`. There are also two hibernate specific properties configured here. The first is `hibernate.hbm2ddl.auto` which is set to `create-drop`. This tells Hibernate to create the necessary database schema when the application is deployed and drop (.e.g. delete) the schema when it's undeployed. This assumes that we are starting from an empty database and will delete the content of the database when undeployed. This is of course not a setting we want to have in production. A common setting is to use `verify`, which will check that the database schema matches the object model and otherwise fail to deploy. However, for the convenience of this scenario, we will leave it at `create-drop` for now. The second property `hibernate.show_sql` and will configure hibernate to log all SQL queries in the JBoss EAP server.log.

**3. Create a datasource**

Next step is to create the datasource. Usually this is done by configuring JBoss EAP using web-console, CLI scripts, or similar. At this stage, we haven't created a database yet, but for test and development purposes we can use an in-memory database like H2. We can define it as follows.

Open the `src/main/webapp/WEB-INF/weather-ds.xml`{{open}} file and click **Copy To Editor** to insert add the following content to the file:

<pre class="file" data-filename="./src/main/webapp/WEB-INF/weather-ds.xml" data-target="replace">
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;datasources xmlns="http://www.jboss.org/ironjacamar/schema"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://www.jboss.org/ironjacamar/schema http://docs.jboss.org/ironjacamar/schema/datasources_1_0.xsd"&gt;
    &lt;!-- The datasource is bound into JNDI at this location. We reference
        this in META-INF/persistence.xml --&gt;
    &lt;datasource jndi-name="java:jboss/datasources/WeatherDS"
                pool-name="weather" enabled="true"
                use-java-context="true"&gt;
        &lt;connection-url&gt;jdbc:h2:mem:weather;DB_CLOSE_ON_EXIT=FALSE;DB_CLOSE_DELAY=-1&lt;/connection-url&gt;
        &lt;driver&gt;h2&lt;/driver&gt;
        &lt;security&gt;
            &lt;user-name&gt;sa&lt;/user-name&gt;
            &lt;password&gt;sa&lt;/password&gt;
        &lt;/security&gt;
    &lt;/datasource&gt;
&lt;/datasources&gt;
</pre>

Now that we have both the JPA persistence configuration and the datasource configuration in place we are ready to extend our model to work with JPA.

**4. Add JPA annotation to the data model**

JPA is a very non-intrusive framework, and all we need to do is to add a couple of annotation to the objects in the domain model.

Let's start with the `City` class. Open `src/main/java/com/redhat/example/weather/City.java`{{open}}

First, we need to tell JPA that this class is an Entity, meaning that it needs to be able to persist to the database. We do this by adding the `@Entity` annotation. Either to that manually at the comment `//TODO: Add Entity annotation` or click the **Copy To Editor**

<pre class="file" data-filename="./src/main/java/com/redhat/example/weather/City.java" data-target="insert" data-marker="//TODO: Add Entity annotation">
@Entity</pre>

Then, we need to indicate which field is to be considered the primary key for the object. We do this by adding annotation `@Id` to the field `private String id`.

<pre class="file" data-filename="./src/main/java/com/redhat/example/weather/City.java" data-target="insert" data-marker="// TODO: add Id annotation">
@Id</pre>

That's it! We are now ready to retrieve object of the type City. However, We also have a data model for Country that holds a list of Cities. Let's go ahead and annotate that as well.

Open `src/main/java/com/redhat/example/weather/Country.java`{{open}}

Add `@Entity` annotation to the class definition.

<pre class="file" data-filename="./src/main/java/com/redhat/example/weather/Country.java" data-target="insert" data-marker="//TODO: Add Entity annotation">
@Entity</pre>

Then add `@Id` annotation to  `public String id`;

<pre class="file" data-filename="./src/main/java/com/redhat/example/weather/Country.java" data-target="insert" data-marker="// TODO: add Id annotation">
@Id</pre>

Now, we also need to tell JPA that the `private List<City> cities;` are related to each other. The relationship is what DB's calls *One-To-Many*, meaning that one single `Country` object has zero, one or more related `City` objects. In JPA we can accomplish this by adding `@OneToMany` annotation to it.

<pre class="file" data-filename="./src/main/java/com/redhat/example/weather/Country.java" data-target="insert" data-marker="// TODO: add one to many annotation">
@OneToMany(fetch = FetchType.EAGER)</pre>

Here we also use an attribute called fetch, and we set it to type `FetchType.EAGER`. The reason for this is that the default fetch type is `FetchType.LAZY`, which means that `City` object related to the Country object isn't retrieved from the database until requests. However, since we are going to return a Country object from a REST service as a JSON string that looks like this:

```json
{
  "cities": [
    {
      "id": "lon",
      "maxTemp": 11,
      "minTemp": 7,
      "name": "London",
      "temp": 9,
      "tempFeelsLike": 9,
      "weatherType": "sunny",
      "wind": 3
    },
    {
      "id": "man",
      "maxTemp": 8,
      "minTemp": 5,
      "name": "Manchester",
      "temp": 7,
      "tempFeelsLike": 3,
      "weatherType": "rainy-7",
      "wind": 10
    },
    {
      "id": "edi",
      "maxTemp": -6,
      "minTemp": -9,
      "name": "Edinburgh",
      "temp": -7,
      "tempFeelsLike": -13,
      "weatherType": "snowy-4",
      "wind": 7
    }
  ],
  "id": "en",
  "name": "England"
}
```

Because of the way that Json-b works we need to cities to be retrieved together with the country object, so therefor we set it to `FetchType.EAGER`.

That is it. We are ready to start using the JPA model. So the next task is to update the rest service to collect it from the database.

**5. Update the rest service to return content from the database**

To find or persist the object in the database using JPA provides an API object called `EntityManager`. Getting an EntityManager is fairly simple since all we have to do is to inject it using `@PersistenceContext`.

Open `src/main/java/com/redhat/example/weather/WeatherService.java`{{open}}

At the TODO comment inject the entity manager like this:

<pre class="file" data-filename="./src/main/java/com/redhat/example/weather/WeatherService.java" data-target="insert" data-marker="//TODO: Inject EntityManager">
@PersistenceContext(unitName = "primary")
EntityManager em;</pre>

Note, that we also set the unitName to "primary". That is actually not necessary since we only have a single persistence unit, JPA would use that one, but as a best practice it's always good to refer to named persistence units.

Now we can use the `EntityManager` to collect Country object. There are many different API calls we can do including creating our own query, however the fastest and easiest way is to use a methods called `find(Class returnType,Object key)` like this:

<pre class="file" data-filename="./src/main/java/com/redhat/example/weather/WeatherService.java" data-target="insert" data-marker="return england; //TODO: Replace with call to database">
return em.find(Country.class,"en"/* TODO: Replace with dynamic call to get selected language*/);</pre>

At the moment the country id is hardcoded as "en", but in the next scenario we will learn how to use CDI to let the user select which country they want to display

**6. Deploy the updates**

We are now ready to test our application in OpenShift.

First, build the application and verify that we do not have any compilation issues.

`mvn clean package`{{execute}}

This will produce a WAR file called ROOT.war under the target directory.

Next, build a container by starting an OpenShift S2I build and provide the WAR file as input.

`oc start-build weather-app --from-file=target/ROOT.war --follow`{{execute}}

When the build has finished, you can test the REST endpoint directly using for example curl.

`curl -s "Accept:application/json" http://weather-app-my-project.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/api/weather | jq`{{execute}}

> **Note:** that it might take a couple of seconds for the application to start so if the command fails at first, please try again.

You should see:

```console
{
  "cities": [
    {
      "id": "lon",
      "maxTemp": 11,
      "minTemp": 7,
      "name": "London",
      "temp": 9,
      "tempFeelsLike": 9,
      "weatherType": "sunny",
      "wind": 3
    },
    {
      "id": "man",
      "maxTemp": 8,
      "minTemp": 5,
      "name": "Manchester",
      "temp": 7,
      "tempFeelsLike": 3,
      "weatherType": "rainy-7",
      "wind": 10
    },
    {
      "id": "edi",
      "maxTemp": -6,
      "minTemp": -9,
      "name": "Edinburgh",
      "temp": -7,
      "tempFeelsLike": -13,
      "weatherType": "snowy-4",
      "wind": 7
    }
  ],
  "id": "en",
  "name": "England"
}
```


You can also test the web application by clicking [here](http://weather-app-my-project.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/index.html)

**Summary**

We have now connected our application to use an in-memory database to collect the data. If you wonder where the data comes from we are using a Hibernate specific feature where you can load data into the database by adding it to `src/main/resources/import.sql`{{open}}. The database tables that are generated here are `City`,`Country` and `Country_City`. The later one is a mapping table that maps Cities with Countries and could potentially be made more efficient by instead using a Foreign key, but in that case, we would have to extend the domain model objects.
