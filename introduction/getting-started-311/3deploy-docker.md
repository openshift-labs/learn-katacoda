In this section, you are going to deploy the front end component of an application called **parksmap**. The web application will display an interactive map, which will be used to display the location of major national parks from all over the world.

# Exercise: Deploying your first Image

The simplest way to deploy an application in OpenShift is to take an existing Docker-formatted image and run it. We are going to use the OpenShift web console to do this, so ensure you have the OpenShift web console open and that you are in the project called `myproject`.

The OpenShift web console provides various options to deploy an application to a project. For this section, we are going to use the *Deploy Image* method. As the project is empty at this point, the *Overview* page should display the following options: *Browse Catalog*, *Deploy Image*, *Import YAML/JSON*, and *Select from Project*. Choose the *Deploy Image* button.

![Add to Project](../../assets/introduction/getting-started-311/3add-to-empty-project.png)

You could also have selected the *Add to Project* drop down menu in the top right corner of the project and selected _Deploy Image_ to go directly to the required tab. We'll use the *Add to Project* option in later sections.

Within the *Deploy Image* page, choose the *Image Name* option. This will be used to reference an existing Docker-formatted image hosted on a Docker Hub Registry. For the name of the image, enter the following:

`openshiftroadshow/parksmap-katacoda:1.2.0`{{copy}}

Press enter or click on the magnifying glass icon to the right of the text entry box to be presented with information about the image:

![Deploy Image](../../assets/introduction/getting-started-311/3deploy-parksmap-image.png)

At this point, OpenShift will pull down and display key information about the image and the pending deployment, as well as populate the *Name* field with `parksmap-katacoda`. This name will be what is used for your application and the various components created that relate to it. Leave this as the generated value as steps given in the upcoming sections will use this name.

You are ready to deploy the existing Docker-formatted image. Hit the blue *Deploy* button at the bottom of the screen, and, in the subsequent page, click the *Continue to the project overview* link. This should bring you back to the *Overview* page where summary information about the application you just deployed will be displayed.

![Console Overview](../../assets/introduction/getting-started-311/3parksmap-overview.png)

These are all the steps you need to run to get a "vanilla" Docker-formatted image deployed on OpenShift. This should work with any Docker-formatted image that follows best practices, such as defining the port any service is exposed on, not needing to run specifically as the *root user* or other dedicated user, and which embeds a default command for running the application.
