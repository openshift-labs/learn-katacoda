# The Project

You start with a basic Maven-based application with the usual `pom.xml` entries for a Quarkus app.

We've also included a frontend HTML file at `src/main/resources/META-INF/resources/index.html`{{open}} that will show our list of Coffee.

# The Application You Will Build

The application is a simple CRUD app with a Front end that lists Coffee and gives options to remove and add more Coffee. 

We also use a CoffeeResource that helps us define those methods with JAX-RS. 

Further more we use a PostgreSQL database, where we create the databses, read from and write to it. 

Lets get started. We have already created a project for you, and lets continue adding functionality to this bare bones project. 

## Add Extension

Like other exercises, we’ll need another extension to start using the PosgtreSQL. Lets install it by clicking on the following command:

`cd /root/projects/rhoar-getting-started/quarkus/reactive-sql &&
  mvn quarkus:add-extension -Dextensions="reactive-pg-client"`{{execute}}

> The first time you add the extension, new dependencies may be downloaded via maven. This should only happen once, after that things will go even faster.

This will add the necessary entries in your `pom.xml`{{open}} to bring in the Reactive PostgreSQL extension. You'll see:

```xml
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-reactive-pg-client</artifactId>
</dependency>
```

## Starting the database
To create a database which you can then connect to, run the command:

``oc new-app postgresql-ephemeral --name database --param DATABASE_SERVICE_NAME=database --param POSTGRESQL_DATABASE=sampledb --param POSTGRESQL_USER=username --param POSTGRESQL_PASSWORD=password``{{execute}}

This will start up an instance of a PostgreSQL database.

Although a database would normally be paired with a persistent volume, we only want to demonstrate how to access the database in this course. The database instance we create here, will therefore only store the database in the filesystem local to the container. This means that if the database were restarted, any changes would be lost. When you deploy a database to be used with your own applications, you would want to look at using persistent volumes.

To monitor progress as the database is deployed and made ready, run the command:

``oc rollout status dc/database``{{execute}}

This command will exit once the database is ready to be used.

When using a database with your front end web application, you will need to configure the web application to know about the database. We are going to skip that in this course.

## Compile in dev mode

With our extension installed, let's begin do a quick compile and check that everything is in place. Click on the following command to start the app in Live Coding mode:

```mvn compile quarkus:dev```{{execute}}

You should see:

```console
Quarkus x.xx.x started in 0.997s. Listening on: http://[::]:8080
Installed features: [cdi, reactive-pg-client, resteasy, resteasy-jsonb, vertx]
```
> The first time you build the app, new dependencies may be downloaded via maven. This should only happen once, after that things will go even faster.

Note the amazingly fast startup time! The app is now running "locally" (within the Linux container in which this exercise runs).

Test that the app is running using the browser to access the `/` endpoint at [this link](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/)

Leave the app running, and let's start adding to it. Everytime we add something to our code, quarkus will hot reload.
