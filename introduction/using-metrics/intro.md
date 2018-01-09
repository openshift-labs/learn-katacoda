Applications deployed on top of OpenShift can benefit on having metrics deployed
to be able to watch pods resource consumption in the web console and use
the horizontally pod autoscaler to create autoscale rules for pods so a
consumption threshold is reached, the pods will be automatically scaled up.

This course will show the metrics deployment based on hawkular-metrics, how
to gather information from the web console and using the ``oc`` tool and
how to create a sample horizontal pod autoscaler and test it.

**NOTE:** The metrics deployment can take a few minutes to be ready as there are
some components that needs to be deployed at run time. If you are curious, take
a look at the [process involved on deploying metrics](https://docs.openshift.org/latest/install_config/cluster_metrics.html)
while they are provisioned.
