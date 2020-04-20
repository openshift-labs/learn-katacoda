In the previous step you've implement the rule unit of our application. We can now implement our rules and queries and start our application.

## Rules

The rules of our rule unit will be implemented in DRL, the Drools Rule Language. DRL is a declarative language in which advanced rules can be defined and implemented, using constructs like rules, functions and queries.

## PersonUnit DRL

We will first implement the skeleton of our `PersonUnit.drl` file in the `src/main/resources` directory of our project.

First we create the proper package in our `src/main/resources` folder: `mkdir -p /root/projects/kogito/adult-service/src/main/resources/org/acme`{{execute T2}}

Next, we create the DRL file by clicking: `adult-service/src/main/resources/org/acme/PersonUnit.drl`{{open}}

Click on the _Copy to Editor_ link to copy the source code into the new `PersonUnit.drl`file.

<pre class="file" data-filename="./adult-service/src/main/resources/org/acme/PersonUnit.drl" data-target="replace">
package org.acme;
//Unit definition

import org.acme.domain.Person;

rule "Is Adult"
when
//Person OOPath
then
//Set adult
end


query "adult"
//Adult query
end
</pre>

We first need to define that this `PersonUnit.drl` is connected to our `PersonUnit`. We do this through `unit` definition under the `package` definition at the top of the DRL file:

<pre class="file" data-filename="./adult-service/src/main/resources/org/acme/PersonUnit.drl" data-target="insert" data-marker="//Unit definition">
unit PersonUnit;
</pre>

Next, we implement the constraint, or left-hand-side of our rule. We will do this in the _OOPath_ syntax. _OOPath_ allows us to write constraints in an XPath-like syntax, allowing users to more easily navigate object hierarchies when writing rules. Also, it allows us to easily define constraints using the rule unit `DataSource` paradigm.

The following constraint matches `Person` facts from the `persons` datastore of our unit, who's age is equal to, or greater than 18:

<pre class="file" data-filename="./adult-service/src/main/resources/org/acme/PersonUnit.drl" data-target="insert" data-marker="//Person OOPath">
  $p: /persons[age &gt;= 18];
</pre>

We can now implement the consequence of our rule, or the right-hand-side (RHS). This the action that will be executed when the rule fires. In our case we want to set the person's `adult` field to true when the rule fires:

<pre class="file" data-filename="./adult-service/src/main/resources/org/acme/PersonUnit.drl" data-target="insert" data-marker="//Set adult">
  $p.setAdult(true);
</pre>


The next thing we need to do for our Kogito application is a query. The query in a unit's DRL, in combination with the rule unit definition, is used by the Kogito code generator to automatically generate the RESTful endpoint for our application.

In this query, we simply want to return all the facts from our `persons` datastore:

<pre class="file" data-filename="./adult-service/src/main/resources/org/acme/PersonUnit.drl" data-target="insert" data-marker="//Adult query">
  $p: /persons;
</pre>

This completes the initial implementation of our DRL.

## Running the application

With our domain model, rule unit and rules implemented, we can now start our application.

`mvn clean compile quarkus:dev`{{execute T1}}

We can inspect the generated RESTful endpoint in the Swagger-UI [Swagger UI](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui) of the application.

We can now send a request to our generated RESTful endpoint using cURL:

`curl -X POST "http://localhost:8080/adult" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"persons\":[{\"age\":18,\"name\":\"Jason\"}]}"`{{execute T2}}

You should see the following result, showing that Jason is an adult:

```console
[{"name":"Jason","age":18,"adult":true}]
```

Stop the application in the first terminal using `CTRL-C`.

## Congratulations!

In this step you've implemented your first Kogito rules and queries. You've seen how Kogito automatically generates the RESTful microservice for you using your business assets, like your rule unit and rules definitions. Finally, we've started our application in Quarkus dev-mode, and fired a request.
