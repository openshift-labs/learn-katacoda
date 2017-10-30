When building an API for other services to consume its important to document the API as well as provide the schema for its use.  For our API we used the Camel Swagger Java component to generate our API document.  Swagger is the world’s largest framework of API developer tools for the OpenAPI Specification(OAS), enabling development across the entire API lifecycle, from design and documentation, to test and deployment.

Here we show where to update our JBoss Fuse Camel API route with the context path for our API Swagger document : 

```
<restConfiguration
            ...
            apiContextPath="/api-docs"
            apiContextListing="false"
            ... />
```

This is already been completed for our API so lets take a look at the Swagger document outpt for your APIs :

``curl http://mypeopleservice-fuselab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/people-service/api-docs``{{execute}}

Your output should look similar to that one presented below:

```
{
  "swagger" : "2.0",
  "info" : {
    "description" : "Camel Rest Example with Swagger that provides an User REST service",
    "version" : "1.2.3",
    "title" : "User Services",
    "contact" : {
      "name" : "The Apache Camel team"
    }
  },
  "host" : "0.0.0.0:8080",
  "basePath" : "/people-service/*",
  "tags" : [ {
    "name" : "user",
    "description" : "User rest service"
  }, {
    "name" : "echo",
    "description" : "Echo rest service"
  } ],
  "schemes" : [ "http" ],
  "paths" : {
    "/echo/ping" : {
      "get" : {
        "tags" : [ "echo" ],
        "summary" : "A ping service",
        "consumes" : [ "application/text" ],
        "produces" : [ "application/text" ],
        "parameters" : [ ],
        "x-camelContextId" : "myCamel",
        "x-routeId" : "route4"
      }
    },
    "/user" : {
      "put" : {
        "tags" : [ "user" ],
        "summary" : "Updates or create a user",
        "consumes" : [ "application/json" ],
        "produces" : [ "application/json" ],
        "parameters" : [ {
          "in" : "body",
          "name" : "body",
          "description" : "The user to update or create",
          "required" : true,
          "schema" : {
            "$ref" : "#/definitions/User"
          }
        } ],
        "x-camelContextId" : "myCamel",
        "x-routeId" : "route2"
      }
    },
    "/user/findAll" : {
      "get" : {
        "tags" : [ "user" ],
        "summary" : "Find all users",
        "consumes" : [ "application/json" ],
        "produces" : [ "application/json" ],
        "parameters" : [ ],
        "responses" : {
          "200" : {
            "description" : "All the users",
            "schema" : {
              "type" : "array",
              "items" : {
                "$ref" : "#/definitions/User"
              }
            }
          }
        },
        "x-camelContextId" : "myCamel",
        "x-routeId" : "route3"
      }
    },
    "/user/{id}" : {
      "get" : {
        "tags" : [ "user" ],
        "summary" : "Find user by id",
        "consumes" : [ "application/json" ],
        "produces" : [ "application/json" ],
        "parameters" : [ {
          "name" : "id",
          "in" : "path",
          "description" : "The id of the user to get",
          "required" : true,
          "type" : "integer"
        } ],
        "responses" : {
          "200" : {
            "description" : "The user that was found",
            "schema" : {
              "$ref" : "#/definitions/User"
            }
          },
          "404" : {
            "description" : "User not found"
          }
        },
        "x-camelContextId" : "myCamel",
        "x-routeId" : "route1"
      }
    }
  },
  "definitions" : {
    "User" : {
      "type" : "object",
      "required" : [ "id", "name" ],
      "properties" : {
        "id" : {
          "type" : "integer",
          "format" : "int32",
          "description" : "The id of the user"
        },
        "name" : {
          "type" : "string",
          "description" : "The name of the user"
        }
      },
      "description" : "Represents an user of the system",
      "x-className" : {
        "type" : "string",
        "format" : "com.redhat.jboss.fuse.User"
      }
    }
  }
}
```

And there you have it.  In just 15 minutes you have spun up a project on OpenShift and rolled out your new API.  Pretty simple isn't it.  Stay tuned as we expand our JBoss Fuse API tutorial by demonstrating how to customize your JBoss Fuse API service. Cheers!!!