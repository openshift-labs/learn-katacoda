The sample project shows the components of a basic Vert.x project laid out in different
subdirectories according to Maven best practices.

**Examine the Quote Generator project structure.**

Switch to the `quote-generator` project

`cd /root/code/quote-generator`{{execute}}

Let’s have a look at the project, as every other project are structured the same way.

`tree`{{execute}}

```markdown
.
|-- README.md 
|-- pom.xml 
|-- src
|   |-- kubernetes/config.json
|   |-- main
|   |   |-- fabric8
|   |   |   `-- deployment.yml 
|   |   |-- java
|   |   |   `-- io/vertx/workshop/quote 
|   |   |               |-- GeneratorConfigVerticle.java
|   |   |               |-- MarketDataVerticle.java
|   |   |               `-- RestQuoteAPIVerticle.java
|   |   `-- solution
|   |       `-- io/vertx/workshop/quote 
|   |                   |-- GeneratorConfigVerticle.java
|   |                   |-- MarketDataVerticle.java
|   |                   `-- RestQuoteAPIVerticle.java
|   `-- test
|       |-- java
|       |   `-- io/vertx/workshop/quote 
|       |               |-- GeneratorConfigVerticleTest.java
|       |               `-- MarketDataVerticleTest.java
|       `-- resources 
`-- target
```

>**NOTE:** To generate a similar project skeleton you can visit the [Vert.x Starter](http://start.vertx.io/) webpage.

Let’s start with the `pom.xml` file. This file specifies the Maven build:

1. Define the dependencies
2. Compile the java code and process resources (if any)
3. Build a fat-jar

A fat-jar (also called uber jar or shaded jar) is a convenient way to package a Vert.x application. It creates an uber-jar containing your application and all its dependencies, including Vert.x. Then, to launch it, you just need to use `java -jar <jar name>` without having to handle the `CLASSPATH`. Vert.x does not dictate a type of packaging. It’s true, fat jars are convenient, but they are not the only way. You can use plain (not fat) jars, OSGi bundles…​
The pom.xml file also contains a set of properties used to configure the application:

* `vertx.verticle` defines the main verticle - the entry point
* `vertx.cluster.name` defines the name of the cluster