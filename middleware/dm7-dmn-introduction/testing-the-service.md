With our Decision Service deployed, we can now test our DMN model. As our Decision Server provides a Swagger interface to interact with its RESTful API, we can simply test our rules via the web-interface provided by the Decision Server.

The Decision Server's Swagger UI can be accessed at http://dmn-demo-kieserver-dmn-demo.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].http-proxy.katacoda.com/docs/

<img src="../../assets/middleware/dm7-loan-application/dm7-swagger-ui.png" width="800" />

In the Swagger UI:

1. Navigate to "KIE Server :: Core"
2. Expand the "GET" operation for resource "/server/containers"
3. Click on "Try it out"
4. Leave the parameters blank and click on "Execute"
5. When asked for credentials use: Username: `developer`{{copy}}, Password: `developer`{{copy}}`
6. Observe the response, which lists the KIE Containers deployed on the server and their status (STARTED, STOPPED).


We can use the Swagger UI to test our Insurance Premium DMN Decision Service. In the Swagger UI:
1. Navigate to "Decision Service :: DMN"
2. Expand the "POST" operation for resource "/server/containers/{id}/dmn"
3. Click on "Try it out"
4. Set the "id" parameter to the name of the KIE Container that hosts our DMN model, in this case `dmn-decision-service_1.0.0`{{copy}}
5. Set "Parameter content type" to application/json.
6. Set "Response content type" to application/json
7. Use the following request as the "body" parameter. Please change the value of the `namespace` field to the value of your specific model, the value we copied in one of the previous steps:

    ```
{
  "model-namespace":"https://github.com/kiegroup/drools/kie-dmn/_C8668BD2-4F07-4150-9580-1D88EFC398F8",
  "model-name":"insurance-premium",
  "decision-name":null,
  "decision-id":null,
  "dmn-context":{
     "Had previous incidents":false,
     "Age":23
  }
}
    ```
    This JSON request is the representation of a Decision Manager DMN request in which we insert 2 input data values, `Age` and `Had previous incidents`. We also define the DMN model that we wan to evaluate through its namespace and nameThe response will look like this:

```
{
  "type": "SUCCESS",
  "msg": "OK from container 'dmn-decision-service'",
  "result": {
    "dmn-evaluation-result": {
      "messages": [],
      "model-namespace": "https://github.com/kiegroup/drools/kie-dmn/_C8668BD2-4F07-4150-9580-1D88EFC398F8",
      "model-name": "insurance-premium",
      "decision-name": null,
      "dmn-context": {
        "Insurance Premium": 2000,
        "Had previous incidents": false,
        "Age": 23
      },
      "decision-results": {
        "_B5A49030-4DEA-4D8A-8E97-9E36EE50B351": {
          "messages": [],
          "decision-id": "_B5A49030-4DEA-4D8A-8E97-9E36EE50B351",
          "decision-name": "Insurance Premium",
          "result": 2000,
          "status": "SUCCEEDED"
        }
      }
    }
  }
}
```

8. Observe the result. The DMN model has been evaluated, and based on the given input, the result of the `Insurance Premium` decision is the value 2000. We can also see that the status of the evaluation is _SUCCEEDED_.

This concludes the testing of our model. Feel free to test your model with different inputs to assess if all your decisions are evaluated correctly.
