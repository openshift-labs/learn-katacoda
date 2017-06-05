In order to access the database from a database administration tool running on your own local machine, it will be necessary to expose the database service outside of the OpenShift cluster.

When a web application is made visible outside of the OpenShift cluster a _Route_ is created. This enables a user to use a URL to access the web application from a web browser. A route is only usually used for web applications which use the HTTP protocol. A route cannot be used to expose a database as they would typically use their own distinct protocol and routes would not be able to work with the database protocol.

There are ways of permanently exposing a database service outside of an OpenShift cluster, however the need to do that would be an exception and not the norm. If only wanting to access the database to perform administration on it, you can instead create a temporary connection back to your local machine using port forwarding. The act of setting up port forwarding creates a port on your local machine which you can then use to connect to the database using a database administration tool.

To setup port forwarding between a local machine and the database running on OpenShift you use the ``oc port-forward`` command. You need to pass the name of the pod and details of the port the database service is using, as well as the local port to use.

The format for the command is:

```
oc port-forward <pod-name> <local-port>:<remote-port>
```

To create a connection to the PostgreSQL database, which uses port 5432, and expose it on the local machine where ``oc`` is being run, as port 15432, use:

``oc port-forward $POD 15432:5432 &``{{execute}}

Port 15432 is used here for the local machine, rather than using 5432, in case an instance of PostgreSQL was also running on the local machine. If an instance of PostgreSQL was running on the local machine and the same port was used, setting up the connection would fail as the port would already be in use.

If you do not know what ports may be available, you can instead use the following format for the command:

```
oc port-forward <pod-name> :<remote-port>
```

In this form, the local port is left off, resulting in a random available port being used. You would need to look at the output from the command to work out what port number was used for the local port and use that.

When the ``oc port-forward`` command is run and the connection setup, it will stay running until the command is interrupted. You would then use a separate terminal window to run the administration tool which could connect via the forwarded connection. In this case, as we only have the one terminal window, we ran the ``oc port-forward`` command as a background job.

You can see that it is still running using: 

``jobs``{{execute}}

With the port forwarding in place, you can now run ``psql`` again. This time it is being run from the local machine, and not inside of the container. Because the forwarded connection is using port 15432 on the local machine, you need to explicitly tell it to use that port rather than the default database port.

``psql sampledb username --host=127.0.0.1 --port=15432``{{execute}}

This will again present you with the prompt for running database operations via ``psql``.

```
Handling connection for 5432
psql (9.2.18, server 9.5.4)
WARNING: psql version 9.2, server version 9.5.
         Some psql features might not work.
Type "help" for help.

sampledb=>
```

You could now dynamically create database tables, add data, or modify existing data.

To exit ``psql`` enter:

``\q``{{execute}}

Because we ran the ``oc port-forward`` command as a background process, we can kill it when done using:

``kill %1``{{execute}}

Running ``jobs`` again we can see it is terminated.

``jobs``{{execute}}

In this exercise we used ``psql``, however you could also use a GUI based database administration tool running on your local machine as well.