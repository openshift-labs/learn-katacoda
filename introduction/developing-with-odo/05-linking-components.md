With both components of our sample application running on the cluster, we need to connect them so they can communicate. OpenShift provides mechanisms to publish communication bindings from a program to its clients. `Odo` expresses these connections with the `link` subcommand.

The `odo link` subcommand takes the name of a *target* component, then of a *source* component. The *target*'s connection information is injected into the *source*'s deployment configuration in the form of environment variables. Try it out to see how host and port information for connecting to the `backend` is given to the `frontend`.

`odo link backend --component frontend`{{execute}}
