The Jupyter on OpenShift project provides Jupyter notebook images which have been purpose built to work best with OpenShift.

Before you can deploy these Jupyter notebook images, you first need to load the images for the Jupyter notebook application into your project in OpenShift. You only need to load this once in a project. You can then use it in creating as many different Jupyter notebook deployments as you need.

In this workshop the step of loading the Jupyter notebook images has already been done for you.

To verify that the images have been loaded run the command:

``oc get imagestreams -o name``{{execute}}

You should see that the `s2i-minimal-notebook` image stream exists.

You can inspect the image stream for the Jupyter notebook by running:

``oc describe imagestream s2i-minimal-notebook``{{execute}}

You should see that the image stream includes tags for `3.5` and `3.6`. These correspond to versions of the image for Python 3.5 and Python 3.6.
