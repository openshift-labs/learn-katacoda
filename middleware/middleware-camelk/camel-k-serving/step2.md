## Running the API integration

You have access to an OpenAPI standard document under `helper` called `openapi.yaml`, that contains operations for:
 - Listing the name of the contained objects
 - Creating a new object
 - Getting the content of an object
 - Deleting an object

#### (OPTIONAL)
The document is written in YAML, this is what it looks like.
You can take this and view it in https://www.apicur.io, as a web based UI to design and view your OpenAPI based APIs.
![apicurio](/openshift/assets/middleware/middleware-camelk/camel-k-serving/Serving-Step2-01-API.png)


```
openapi: 3.0.2
info:
    title: Camel K Object API
    version: 1.0.0
    description: A CRUD API for an object store
paths:
    /:
        get:
            responses:
                '200':
                    content:
                        application/json:
                            schema:
                                type: array
                                items:
                                    type: string
                    description: Object list
            operationId: list
            summary: List the objects
    '/{name}':
        get:
            responses:
                '200':
                    content:
                        application/octet-stream: {}
                    description: The object content
            operationId: get
            summary: Get the content of an object
        put:
            requestBody:
                description: The object content
                content:
                    application/octet-stream: {}
                required: true
            responses:
                '200':
                    description: The object has been created
            operationId: create
            summary: Save an object
        delete:
            responses:
                '204':
                    description: Object has been deleted
            operationId: delete
            summary: Delete an object
        parameters:
            -
                name: name
                description: Name of the object
                schema:
                    type: string
                in: path
                required: true
    /list:
        get:
            responses:
                '200':
                    content:
                        application/json:
                            schema:
                                type: array
                                items:
                                    type: string
            operationId: list
            summary: List the objects

```



#### IMPLEMENT API WIH CAMEL K
Let's create the camel route that implements the operations that was defined in the API.  
Go to the text editor on the right, under the folder /root/camel-api. Right click on the directory and choose New -> File and name it `API.java`.

Paste the following code into the application.

<pre class="file" data-filename="API.java" data-target="replace">
// camel-k: language=java dependency=camel-quarkus-openapi-java

import org.apache.camel.builder.AggregationStrategies;
import org.apache.camel.builder.RouteBuilder;

public class API extends RouteBuilder {
  @Override
  public void configure() throws Exception {

    // All endpoints starting from "direct:..." reference an operationId defined
    // in the "openapi.yaml" file.

    // List the object names available in the S3 bucket
    from("direct:list")
      .to("aws2-s3://{{api.bucket}}?operation=listObjects")
      .split(simple("${body}"), AggregationStrategies.groupedBody())
        .transform().simple("${body.key}")
      .end()
      .marshal().json();


    // Get an object from the S3 bucket
    from("direct:get")
      .setHeader("CamelAwsS3Key", simple("${header.name}"))
      .to("aws2-s3://{{api.bucket}}?operation=getObject")
      .convertBodyTo(String.class);

    // Upload a new object into the S3 bucket
    from("direct:create")
      .setHeader("CamelAwsS3Key", simple("${header.name}"))
      .to("aws2-s3://{{api.bucket}}");


    // Delete an object from the S3 bucket
    from("direct:delete")
      .setHeader("CamelAwsS3Key", simple("${header.name}"))
      .to("aws2-s3://{{api.bucket}}?operation=deleteObject")
      .setBody().constant("");

  }
}

</pre>

Let's add the for configuring and connecting to Minio.  
Go to the text editor on the right, under the folder /root/camel-api. Right click on the directory and choose New -> File and name it `minio.properties`.


<pre class="file" data-filename="minio.properties" data-target="replace">
# Bucket (referenced in the routes)
api.bucket=camel-k

# Minio information injected into the MinioCustomizer
minio.endpoint=http://minio:9000
minio.access-key=minio
minio.secret-key=minio123

# Camel AWS2 S3
camel.component.aws2-s3.region=EU_WEST_1
camel.component.aws2-s3.access-key={{minio.access-key}}
camel.component.aws2-s3.secret-key={{minio.secret-key}}
camel.component.aws2-s3.uri-endpoint-override = {{minio.endpoint}}
camel.component.aws2-s3.override-endpoint = true

# General configuration
camel.context.rest-configuration.api-context-path=/api-doc
</pre>


We are now ready to start up the application, simply point to the OpenAPI standard document and along with the implemented Camel K application. Notice we are also pointing to the configuration file too.

``kamel run --name api camel-api/API.java --property-file camel-api/minio.properties --open-api helper/openapi.yaml``{{execute}}

Wait for the integration to be running (you should see the logs streaming in the terminal window).

```
log
```

After running the integration API, you should be able to call the API endpoints to check its behavior.
Make sure the integration is running, by checking its status:

``oc get integrations``{{execute}}

An integration named api should be present in the list and it should be in status Running.

``
NAME    PHASE   KIT
api     Running kit-bte009bi9eodqqhokkkg
``

There's also a kamel get command which is an alternative way to list all running integrations.
``kamel get ``{{execute}}

NOTE: it may take some time, the first time you run the integration, for it to reach the Running state.

After the integration has reached the running state, you can get the route corresponding to it via the following command:

``URL=http://$(oc get route api -o jsonpath='{.spec.host}')``{{execute}}

Get the list of objects:
``curl $URL/``{{execute}}

Since there are nothing in the storage, you won't see anything for now.

Upload an object:
``curl -i -X PUT --header "Content-Type: application/octet-stream" --data-binary "/root/camel-api/API.java" $URL/example``{{execute}}

Get the new list of objects:
``curl -i $URL/``{{execute}}

You will see the *['example']* that we have just uploaded from previous step

Get the content of a file:
``curl -i $URL/example``{{execute}}

You will see what was in your *API.java* file

Delete the file:
``curl -i -X DELETE $URL/example``{{execute}}

Get the list of objects for the last time:
``curl -i $URL/``{{execute}}

The storage is emtpy again, so nothing will return.

Congratulations, you now have a running Restful web Application base on the OpenAPI Document.

Now, let's go ahead and uninstall the API instance.

``kamel delete api``{{execute}}
