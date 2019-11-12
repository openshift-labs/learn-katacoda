The minimal Jupyter notebook images that have been loaded can be deployed as is, but to make it easier to secure access, add persistent storage, define resources, as well as use it as a Source-to-Image (S2I) builder to create custom Jupyter notebook images, the Jupyter on OpenShift project also provides a set of OpenShift templates.

As with the Jupyter notebook images, for this workshop these have already been loaded for you.

To verify that the templates have been loaded for you, run:

``oc get templates``{{execute}}

The purpose of the OpenShift templates which have been loaded are:

* `notebook-deployer` - Template for deploying a Jupyter notebook image.

* `notebook-builder` - Template for building a custom Jupyter notebook image using Source-to-Image (S2I) against a hosted Git repository. Python packages listed in the `requirements.txt` file of the Git repository will be installed and any files, including notebook images, will be copied into the image. The image can then be deployed using the `notebook-deployer` template.

* `notebook-quickstart` - Template for building and deploying a custom Jupyter notebook image. This combines the functionality of the `notebook-builder` and `notebook-deployer` templates.

* `notebook-workspace` - Template for deploying a Jupyter notebook instance which also attaches a persistent volume, and copies any Python packages and notebooks included in the image, into the persistent volume. Any work done on the notebooks, or to install additional Python packages, will survive a restart of the Jupyter notebook environment. A webdav interface is also enabled to allow remote mounting of the persistent volume to a local computer.

In this workshop you will be using the `notebook-deployer` template.

To see details about this template and what parameters can be provided when using the template, run the command:

``oc describe template notebook-deployer``{{execute}}

Check out the other workshops available here for more information on this and the other templates.
