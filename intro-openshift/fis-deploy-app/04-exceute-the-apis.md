In this next section of the scenario we will use the JBoss FIS 2.0 Hawtio Console to test and review the behavior of our new route.  

### What is Hawtio? 
The JBoss Fuse Hawtio console provides in depth details into the Camel and ActiveMQ components deployed as part of a JBoss FIS 2.0 application. This includes standard JVM resources such as memeory and threads as well as JMX attributes and operations. The Hawtio console also provides a full selection of tools used to drill into the JBoss FIS 2.0 Camel and ActiveMQ components.

Lets get started by taking a look at some statistics provided by the console.  Select the "Route Diagram" to see more detail implementation:

![Select Diagram route](../../assets/intro-openshift/fis-deploy-app/03-select-diagram-route.png)

The Route Diagram tab provids a graphical review of all the routes currently deployed in our API application.  After selecting this tab we should see something similar to what is pictured below; 5 routes starting with various EIP depictions of route behavior: WHAT IS EIP?

![Detail Camel Route](../../assets/intro-openshift/fis-deploy-app/03-detail-camel-route.png)


Now lets take a look at calling our APIs and tracing that output on the Hawtio console.

We have there are three APIs avalible for us to call.  They are:

- Retrieve User
- Create User  
- Retrieve All Users

HOW DID YOU KNOW THIS? CAN YOU PLEASE SHOW ME IN THE INTERFACE WHERE I COULD HAVE DISCOVERED THIS INFORMATION.

Switch back over to the _Terminal_ screen and let's try retrieving user information by running:

``curl http://mypeopleservice-fuselab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/people-service/user/123``{{execute}}

This will display output similar to:

```
{
  "id" : 123,
  "name" : "John Doe"
}
```
Go back to the _Dashboard view_, in the **Hawtio console**, you should be able to see the number of message pass through route "get user" has been updated to "1":

_If the numbers do not update at first, click over to the Source or Inflight tab and then back to the Route Diagram screen..._ I NEVER GET THE NUMBERS TO UPDATE, EVEN AFTER CURL'ING FOR DONALD DUCK

![Get user route udpate](../../assets/intro-openshift/fis-deploy-app/04-get-user-route-update.png)


Lets make some more calls to our User API service.  Switch back over to the _Terminal_ screen and and run each of the following :

``curl http://mypeopleservice-fuselab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/people-service/user/456``{{execute}}

This will display output similar to:

```
{
  "id" : 456,
  "name" : "Donald Duck"
}
```

``curl http://mypeopleservice-fuselab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/people-service/user/789``{{execute}}

This will display output similar to:

```
{
  "id" : 789,
  "name" : "Slow Turtle"
}
```

To retrieve entire user list, try running :

``curl http://mypeopleservice-fuselab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/people-service/user/findall``{{execute}}

This will display output similar to:

```
[ {
  "id" : 123,
  "name" : "John Doe"
}, {
  "id" : 456,
  "name" : "Donald Duck"
}, {
  "id" : 789,
  "name" : "Slow Turtle"
} ]
```

Back to _Dashboard view_, in the **Hawtio console**, numbers of API calls are also refected on the diagram:

![Camel stats update](../../assets/intro-openshift/fis-deploy-app/04-camel-stats-update.png)

And lastly, try adding another user to the list.  Switch back over to the _Terminal_ screen and run :

``curl -H "Content-Type: application/json" -X PUT -d '{"id":888, "name" : "Christina"}' http://mypeopleservice-fuselab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/people-service/user``{{execute}}

This will display output similar to:

```
{
  "id" : 888,
  "name" : "Christina"
}
```
Over in the _Dashboard_ browser our _Route Diagram_ should have even more updates as shown below :

![Camel stats update after PUT](../../assets/intro-openshift/fis-deploy-app/04-camel-stats-update-put.png)

Now lets see how the User Service API is documented by clicking the _Continue_ button.
