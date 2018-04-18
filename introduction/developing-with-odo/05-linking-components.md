
`odo link frontend backend`{{execute}}

defines two environment variables for the frontend application

``
COMPONENT_BACKEND_ADDRESS=<some address>
COMPONENT_BACKEND_PORT=<some port>
``

and restart it.

`oc env dc frontend COMPONENT_BACKEND_ADDRESS="backend" COMPONENT_BACKEND_PORT="8080"`{{execute}}
