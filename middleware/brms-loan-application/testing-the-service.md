With our *Decision Server* deployed, we can now test our rules. As our *Decision Server* exposes a REST API, we can simply test our service using `cURL`.

We first need to determine the endpoint exposed by our application's *Route*.

`oc get route`{{copy}}


Once the DecisionServer with our project has been deployed, we can send it a Loan Application request. We can use the following cURL command to send a *Loan Application* request to the server:

`curl -u brmsAdmin:jbossbrms@01 -X POST -H "Accept: application/json" -H "Content-Type: application/json" -H "X-KIE-ContentType: JSON" -d '{ "commands":[ { "insert":{ "object":{ "com.redhat.demos.loandemo.Applicant":{ "creditScore":230, "name":"Jim Whitehurst" }}, "out-identifier":"applicant" }}, { "insert":{ "object":{ "com.redhat.demos.loandemo.Loan":{ "amount":2500, "approved":false, "duration":24, "interestRate":1.5 }}, "out-identifier":"loan" }}, { "fire-all-rules":{  }}]}' http://loan-demo-loan-demo.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/kie-server/services/rest/server/containers/instances/container-loan10`{{copy}}

Because the inline JSON in the cUrl command is a bit hard to read, we have printed the formatted JSON request below:

```
{
  "commands":[
    {
      "insert":{
        "object":{
          "com.redhat.demos.loandemo.Applicant":{
            "creditScore":230,
            "name":"Jim Whitehurst"
          }
        },
        "out-identifier":"applicant"
      }
    },
    {
      "insert":{
        "object":{
          "com.redhat.demos.loandemo.Loan":{
            "amount":2500,
            "approved":false,
            "duration":24,
            "interestRate":1.5
          }
        },
        "out-identifier":"loan"
      }
    },
    {
      "fire-all-rules":{
      }
    }
  ]
}
```

This JSON request is the representation of a BRMS “BatchExecutionCommand” in which we insert 2 objects (facts) into the rules engine, Applicant and Loan, after which we give the command to fire the rules. The response will look like this:

```
{
  "type":"SUCCESS",
  "msg":"Container 166d7802fc076eb3d6eda22cf186071c successfully called.",
  "result":{
    "execution-results":{
      "results":[
        {
          "key":"loan",
          "value":{
            "com.redhat.demos.loandemo.Loan":{
              "amount":2500,
              "approved":true,
              "duration":24,
              "interestRate":1.5
            }
          }
        },
        {
          "key":"applicant",
          "value":{
            "com.redhat.demos.loandemo.Applicant":{
              "creditScore":230,
              "name":"Jim Whitehurst"
            }
          }
        }
      ],
      "facts":[
        {
          "key":"loan",
          "value":{
            "org.drools.core.common.DefaultFactHandle":{
              "external-form":"0:6:1508714685:1508714685:6:DEFAULT:NON_TRAIT:com.redhat.demos.loandemo.Loan"
            }
          }
        },
        {
          "key":"applicant",
          "value":{
            "org.drools.core.common.DefaultFactHandle":{
              "external-form":"0:5:576291744:576291744:5:DEFAULT:NON_TRAIT:com.redhat.demos.loandemo.Applicant"
            }
          }
        }
      ]
    }
  }
}
```

Note that the application has been approved, as the “approved” field of our Loan object has been set to “true”.
