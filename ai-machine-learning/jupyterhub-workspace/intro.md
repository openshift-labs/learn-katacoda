The [Project Jupyter](https://jupyter.org/) web site describes Jupyter notebooks as:

> an open-source web application that allows you to create and share documents that contain live code, equations, visualizations and narrative text. Uses include: data cleaning and transformation, numerical simulation, statistical modeling, data visualization, machine learning, and much more.

Jupyter notebooks can be deployed direct to Linux, macOS or Windows environments, or in containerized environments such as Docker, Kubernetes and OpenShift.

In this workshop you will learn how you can provide persistent workspaces for multiple users, for working on Jupyter notebooks, using JupyterHub. Access to the Jupyter notebooks will be gated using OpenShift cluster authentication. The Jupyter notebook instance will be attached to the OpenShift cluster so that users can interact with and deploy workloads to the cluster required by the Jupyter notebooks.

The examples shown will make use of sample Jupyter notebook images, JupyterHub images, and templates, from the [Jupyter on OpenShift](https://github.com/jupyter-on-openshift) project, a community project for demonstrating how Jupyter notebooks and JupyterHub can be deployed to OpenShift.
