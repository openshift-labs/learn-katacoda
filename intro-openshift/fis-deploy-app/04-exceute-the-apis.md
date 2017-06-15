Now lets take a look at calling our APIs and tracing that output on the Hawtio console.

We have there are three APIs avalible for us to call.  They are:

- Retrieve User
- Create User  
- Retrieve All Users

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

_If the numbers do not update at first, click over to the Source or Inflight tab and then back to the Route Diagram screen..._

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