A horizontal pod autoscaler, defined by a
`HorizontalPodAutoscaler` object, specifies how the system should
automatically increase or decrease the scale of a `replication controller` or
`deployment configuration`, based on metrics collected from the pods that belong
to that `replication controller` or `deployment configuration`. OpenShift
prevents unnecessary autoscaling during resource spikes, such as during start
up.

In OpenShift versions prior to 3.6, there was only CPU metrics support. Starting
with OpenShift version 3.6,  there are two metrics supported by the
`horizontal pod autoscaler`:

* CPU requested
* Memory requested

In this lesson we will create an ``hpa`` for requested CPU.

The ``hpa`` object specify:

* Max number of replicas of the pod
* Min number of replicas of the pod
* Utilization percentage that will trigger the scaling

The utilization percentage means the pod should have limits to calculate the
usage, so the first task will be to modify the current application to have CPU
limits. We will configure a 80 milicores limit for CPU requests to our app:

``oc patch dc/guestbook -p '{"spec":{"template":{"spec":{"containers":[{"name":"guestbook","resources":{"limits":{"cpu":"80m"}}}]}}}}'``{{execute}}

**NOTE:** This will trigger a new deployment as the ``deploymentConfig`` has
been modified and there is a `ConfigChange` trigger by default.

Next step is to create the ``hpa`` to trigger the scale process if the CPU usage
is higher than the 20% (to be able to see the scale up quickly) and with a
maximum of 3 pods by using ``oc``:

``oc autoscale dc/guestbook --min 1 --max 3 --cpu-percent=20``{{execute}}
