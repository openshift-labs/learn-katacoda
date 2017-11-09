In this course you learnt how with the new service catalog and builtin in template service broker for OpenShift 3.7, you can easily deploy a database and then bind it to an application.

Any details of a provisioned service are stored in a _Secret_ and can be injected into an application using environment variables or through a volume mount. The application code then need only check for these and use them when connecting to the service, such as the database which was used in this course.

For more details on the service catalog and template service broker see:

* https://docs.openshift.org/latest/architecture/service_catalog/index.html
* https://docs.openshift.org/latest/architecture/service_catalog/template_service_broker.html
