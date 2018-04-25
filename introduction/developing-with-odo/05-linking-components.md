Now that we have both compnents we link the backend into the frontend
With both components of our sample application running on the cluster, we need to connect them together. `Odo` expresses this connection with the `link` subcommand.

The `link` subcommand takes the name of a *target* component, then of the *source* component. The *target*'s connection information is injected into the *source*'s deployment configuration in the form of two environment variables. These variables are named `COMPONENT_BACKEND_HOST` and `COMPONENT_BACKEND_PORT`.

`odo link backend --component frontend`{{execute}}
