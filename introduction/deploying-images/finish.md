In this course you learnt about deploying an existing Docker-formatted container image to OpenShift. You first deployed an image direct from an external image registry. This was followed by importing an image into the OpenShift internal registry, and then deploying the image from the internal registry.

You can find a summary of the key commands covered below. To see more information on each ``oc`` command, run it with the ``--help`` option.

``oc new-app <docker-image> --name <name>``: Deploy an application from a Docker-formatted image found on an external image registry. If there is any ambiguity as to the source of the image, use the ``--docker-image`` option.

``oc new-app <image-stream> --name <name>``: Deploy an application from a Docker-formatted image found in the internal image registry. If there is any ambiguity as to the source of the image, use the ``--image-stream`` option.

``oc import-image <docker-image> --confirm``: Import a Docker-formatted image found on an external image registry, causing it to be pulled into the internal image registry.
