One of the benefits of OpenShift over a traditional PaaS supporting only 12-factor or cloud native applications is that you have access to persistent volumes. This means you can attach storage to your web applications, or run applications such as databases.

Databases deployed to OpenShift will typically be used to support the operations of a front end web application and therefore only need to be accessible by other applications running in the same OpenShift cluster.

To manage a database, it can though be convenient to use a database client running on your own local machine. This could be a command line client, or a GUI based application.

In this course you will learn how to use port forwarding to temporarily expose a database, allowing you to access it from a database tool running on your own local machine.

You will be using just the ``oc`` command line tool in this exercise. We have left the OpenShift web console enabled if you wish to also explore the resource objects using it.