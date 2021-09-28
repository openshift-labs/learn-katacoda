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

## Create basic project

Let's create the basic Quarkus _Hello World_ application and include the necessary spring extensions. Click this command to create the project:

`cd /root/projects/quarkus &&
 mvn io.quarkus:quarkus-maven-plugin:2.0.0.Final:create \
    -DprojectGroupId=org.acme \
    -DprojectArtifactId=fruit-taster \
    -Dextensions="spring-data-jpa,spring-web,spring-di,jdbc-postgres, jdbc-h2"`{{execute T1}}

This will use the Quarkus Maven Plugin and generate a basic Maven project for you in the `fruit-taster` subdirectory and include the following extensions to enable Spring annotations and APIs:

* **spring-data-jpa** - Adds Spring Data annotations like `@CrudRepository` allowing integration with database-backed JPA repositories
* **spring-web** - Adds Spring Web annotations like `@RestController`, `@RequestMapping`, `@PathVariable`, `@GetMapping`, etc
* **spring-di** - Adds Spring DI annotations like `@Autowired`, `@Configuration`, `@Component`, etc
* **jdbc-postgres** - Driver for Postgresql database. Note this is the `jdbc` variant. Reactive programmers may be interested in the [Reactive Postgres Client](https://quarkus.io/guides/reactive-postgres-client).
* **jdbc-h2** - We also use the h2 database for local development

## Start the app

First, switch to the directory in which the app was built:

`cd /root/projects/quarkus/fruit-taster`{{execute}}

Let's begin Live Coding. Click on the following command to start the app in _Live Coding_ mode:

`mvn quarkus:dev -Dquarkus.http.host=0.0.0.0`{{execute}}

You should see:

```console
__  ____  __  _____   ___  __ ____  ______
 --/ __ \/ / / / _ | / _ \/ //_/ / / / __/
 -/ /_/ / /_/ / __ |/ , _/ ,< / /_/ /\ \
--\___\_\____/_/ |_/_/|_/_/|_|\____/___/
INFO  [io.quarkus] (Quarkus Main Thread) fruit-taster 1.0.0-SNAPSHOT on JVM (powered by Quarkus xx.xx.xx.Final) started in xxxs. Listening on: http://0.0.0.0:8080
INFO  [io.quarkus] (Quarkus Main Thread) Profile dev activated. Live Coding activated.
INFO  [io.quarkus] (Quarkus Main Thread) Installed features: [agroal, cdi, hibernate-orm, hibernate-orm-panache, jdbc-h2, jdbc-postgresql, narayana-jta, resteasy, resteasy-jackson, smallrye-context-propagation, spring-data-jpa, spring-di, spring-web]

--
Tests paused, press [r] to resume, [h] for more options>
```
> The first time you build the app, new dependencies may be downloaded via maven. This should only happen once, after that things will go even faster.

Test that the app is running by accessing the simple `hello` endpoint:

`cd /root/projects/quarkus/fruit-taster && \
  curl http://localhost:8080/greeting`{{execute T2}}

> You may need to click this command again in case it doesn't execute properly on first click

you should see

```console
Hello Spring
```

This app doesn't use any Spring annotations yet. You'll _live code_ those in the next few steps while the app continues to run.