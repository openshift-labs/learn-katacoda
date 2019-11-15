Whenever you deploy any application from an existing Docker-formatted container image using the _Deploy Image_ page of the OpenShift web console, it will by default only be visible internally to the OpenShift cluster, and usually only to other applications within the same project.

If the application is a web application and you need to make it visible outside of the OpenShift cluster so users can access it, you will need to expose it via a _Route_.

That an application is not visible and may need to be exposed to be visible can be determined from the _Overview_ page for a project and the details of the application displayed. In particular, if the application is not being exposed, then _Create Route_ will be displayed to the right of the application name.

![Adding a Route](../../assets/introduction/deploying-images-36/03-select-create-route.png)

Routes can be used to expose any application which communicates over HTTP. OpenShift can handle termination for secure HTTP connections, or a secure connection can be tunnelled through direct to the application, with the application handling termination of the secure connection. Non HTTP applications can be exposed via a tunnelled secure connection if the client supports the SNI extension for a secure connection using TLS.

To expose the sample application you have deployed, click on _Create Route_. This will display a page for entering the route details.

![Route Details](../../assets/introduction/deploying-images-36/03-create-route-details.png)

If you do not modify any of the pre-populated values, OpenShift will automatically assign a hostname for the application as a sub domain of the hostname for the OpenShift cluster.

To override the hostname you can modify the _Hostname_ field. For this to work you would need to control the DNS which has delegated authority for that hostname and be able to set up a ``CNAME`` for the hostname mapping to the hostname for the OpenShift cluster's router.

No matter what port the application listens to internally to the OpenShift cluster, port 8080 in this case, the external route will use the standard port 80 for the HTTP connection, and the standard port 443 for a secure HTTP connection.

Before creating the route, ensure that the ``app`` label is listed with value ``blog-django-py``. Add this label if not present as we will be using it later.

![Route Details](../../assets/introduction/deploying-images-36/03-create-route-labels.png)

Leaving all all other values as their defaults, click on _Create_ and you will be returned to the _Overview_ page for the project. Instead of _Create Route_, you should now see the URL by which the exposed application can be accessed from a web browser.

![Exposed Route](../../assets/introduction/deploying-images-36/03-exposed-route-url.png)

Click on the URL and a new browser window should open showing the sample application.

![Sample Application](../../assets/introduction/deploying-images-36/03-sample-blog-application.png)
