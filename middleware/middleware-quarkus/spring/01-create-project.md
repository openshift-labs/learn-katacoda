## Create basic project

Let's create the basic Quarkus _Hello World_ application and include the necessary spring extensions. Click this command to create the project:

`mvn io.quarkus:quarkus-maven-plugin:1.0.0.CR1:create \
    -DprojectGroupId=org.acme \
    -DprojectArtifactId=fruit-taster \
    -DclassName="org.acme.quickstart.GreetingResource" \
    -Dextensions="spring-data-jpa,spring-web,spring-di,jdbc-postgres" \
    -Dpath="/hello"`{{execute}}

This will use the Quarkus Maven Plugin and generate a basic Maven project for you in the `fruit-taster` subdirectory and include the following extensions to enable Spring annotations and APIs:

* **spring-data-jpa** - Adds Spring Data annotations like `@CrudRepository` allowing integration with database-backed JPA repositories
* **spring-web** - Adds Spring Web annotations like `@RestController`, `@RequestMapping`, `@PathVariable`, `@GetMapping`, etc
* **spring-di** - Adds Spring DI annotations like `@Autowired`, `@Configuration`, `@Component`, etc
* **jdbc-postgres** - Driver for Postgresql database. Note this is the `jdbc` variant. Reactive programmers may be interested in the [Reactive Postgres Client](https://quarkus.io/guides/reactive-postgres-client).

## Start the database

We'll need a locally running database to test our app during Live Coding. Click the following command to start one in the background:

`docker run --ulimit memlock=-1:-1 --rm=true --memory-swappiness=0 \
    --name postgres-database -e POSTGRES_USER=sa \
    -e POSTGRES_PASSWORD=sa -e POSTGRES_DB=fruits \
    -p 5432:5432 postgres:10.5 >& /dev/null &`{{execute}}

## Start the app

First, switch to the directory in which the app was built:

`cd /root/projects/quarkus/fruit-taster`{{execute}}

Let's begin Live Coding. Click on the following command to start the app in _Live Coding_ mode:

`mvn compile quarkus:dev`{{execute}}

You should see:

```console
INFO  [io.qua.dep.QuarkusAugmentor] (main) Beginning quarkus augmentation
INFO  [io.qua.dep.QuarkusAugmentor] (main) Quarkus augmentation completed in 1283ms
INFO  [io.quarkus] (main) Quarkus x.xx.x started in 1.988s. Listening on: http://[::]:8080
INFO  [io.quarkus] (main) Installed features: [agroal, cdi, hibernate-orm, jdbc-postgresql, narayana-jta, resteasy, spring-data-jpa, spring-di, spring-web]
```
> The first time you build the app, new dependencies may be downloaded via maven. This should only happen once, after that things will go even faster.

Note the amazingly fast startup time! The app is now running "locally" (within the Linux container in which this exercise runs).

Test that the app is running by accessing the simple `hello` endpoint:

`cd /root/projects/quarkus/fruit-taster && \
  curl http://localhost:8080/hello`{{execute T2}}

> You may need to click this command again in case it doesn't execute properly on first click

you should see

```console
hello
```

This app doesn't use any Spring annotations yet. You'll _live code_ those in the next few steps while the app continues to run.