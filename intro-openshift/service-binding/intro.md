Web applications are not always completely stateless and would usually use
a database for storing data which needs to be shared between instances of
the web application.

The ability of OpenShift to provide persistent storage means that you can
deploy a database along side the web application. This database would only
be visible within the same project as the web application, however it still
should be secured with a database password.

In this course you will learn how to deploy a web application, along with a
database for storing data entered via the web application. You will then
update the deployment configuration for the web application configuration
so that the database credentials will be passed to the web application.
