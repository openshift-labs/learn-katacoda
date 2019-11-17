Deploying JupyterHub requires a bit more work to setup than just deploying the JupyterHub image, so templates are available to make this task easier.

As with the Jupyter notebook and JupyterHub images, for this workshop these have already been loaded for you.

To verify that the templates have been loaded for you, run:

``oc get templates``{{execute}}

The purpose of the OpenShift templates which have been loaded are:

* `jupyterhub-deployer` - Template for deploying a JupyterHub service using an existing Jupyter notebook image.

* `jupyterhub-builder` - Template for building a custom JupyterHub image using Source-to-Image (S2I) against a hosted Git repository. Custom JupyterHub configuration will be combined with the base JupyterHub image.

* `jupyterhub-quickstart` - Template for deploying a JupyterHub service, using a custom Jupyter notebook image built using Source-to-Image (S2I).

* `jupyterhub-workspace` - Template for deploying a JupyterHub service, with optional persistent storage for Jupyter notebooks and with access gated using OpenShift cluster authentication. Instances will also have access to the cluster to deploy additional workloads required by the notebooks.

In this workshop you will be using the `jupyterhub-workspace` template.
