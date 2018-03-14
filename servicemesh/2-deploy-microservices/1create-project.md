We will deploy three microservices (customer, preference, recommendation) implemented using Spring Boot and Vert.x.

The `customer` microservice makes a request to `preference` that makes a request to `recommendation`.

Let's deploy each one of them to a new project called `tutorial`.

To create a new project, execute `oc new-project tutorial`{{execute T1}}

Now let's add the `privileged` SCC to this project.

Execute: `oc adm policy add-scc-to-user privileged -z default -n tutorial`{{execute T1}}
