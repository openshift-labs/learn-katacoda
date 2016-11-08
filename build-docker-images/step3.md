Once the build has completed successfully, the created Docker Image is pushed to the Docker Registry. OpenShift has built-in support for hosting a Docker Registry for built Images. This Registry is used to distribute images across multiple nodes within the cluster. The configuration of an externally hosted Docker Registry is supported.

On the master node, it is possible to view the built Docker Images via the Docker CLI command `docker images | head -n2`{{execute}}

The Docker Image names are prefixed with the URL of the Docker Registry. If the image was sourced from an external registry, then the name appears in the prefix, for example, _docker.io_.
