In the empty project, select the _Add to Project_ button in the centre of the page.

![Adding to Empty Project](../../assets/introduction/deploying-python-36/02-add-to-project-empty.png)

You should be presented with the catalog browser.

![Catalog Browser](../../assets/introduction/deploying-python-36/02-add-to-project-browser.png)

If applications had previously been deployed to the project, or you were not on the project _Overview_ page, you can use the _Add to Project_ link in the menu bar.

![Adding via Menu Bar](../../assets/introduction/deploying-python-36/02-add-to-project-menubar.png)

In this course you are going to deploy a web application which is implemented using the Python programming language.

Select the _Python_ category from the catalog browser. Any options for deploying applications which are related to Python will be displayed.

![Available Python Versions](../../assets/introduction/deploying-python-36/02-deploy-python-versions.png)

In the environment used for this course, the only option presented will be that for the Python Source-to-Image (S2I) builder.

For this exercise leave the version as ``latest``, which in this environment maps to Python 3.5.

Click on _Select_ to bring up the deployment options for the Python S2I builder.

![Python Deployment Options](../../assets/introduction/deploying-python-36/02-deploy-python-options.png)

For the _Name_ to be given to resources, enter:

`blog`{{copy}}

For the _Git Repository URL_ enter:

`https://github.com/openshift-katacoda/blog-django-py`{{copy}}

When you are ready, at the bottom of the page click on _Create_. This will take you to a splash page confirming the application has been created.

![Application Image Details](../../assets/introduction/deploying-python-36/02-continue-to-overview.png)

Click on _Continue to overview_ and you will be returned to the _Overview_ page, where you can view the details of the application created and monitor progress as it is built and deployed.

![Application Overview](../../assets/introduction/deploying-python-36/02-build-in-progress.png)
