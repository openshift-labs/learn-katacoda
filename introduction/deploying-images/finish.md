In this course you learnt about deploying an existing  container image to OpenShift.

You can find a summary of the key commands covered below. To see more information on each ``oc`` command, run it with the ``--help`` option.

``oc new-app <docker-image> --name <name>``: Deploy an application from a container image found on an external image registry. If there is any ambiguity as to the source of the image, use the ``--docker-image`` option.
