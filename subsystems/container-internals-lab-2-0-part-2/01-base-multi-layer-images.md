The goal of this exercise is to understand the difference between base images and multi-layered images (repositories). Also, we'll try to understand the difference between an image layer and a repository.

Let's take a look at some base images. We will use the podman history command to inspect all of the layers in these repositories. Notice that these container images have no parent layers. These are base images, and they are designed to be built upon. First, let's look at the full ubi7 base image:

`podman history registry.access.redhat.com/ubi7/ubi:latest`{{execute}}

Now, let's take a look at the minimal base image, which is part of the Red Hat Universal Base Image (UBI) collection. Notice that it's quite a bit smaller:

`podman history registry.access.redhat.com/ubi7/ubi-minimal:latest`{{execute}}

Now, using a simple Dockerfile we created for you, build a multi-layered image:

`podman build -t ubi7-change -f ~/labs/lab2-step1/Dockerfile`{{execute}}

Do you see the newly created ubi7-change tag?

`podman images`{{execute}}

Can you see all of the layers that make up the new image/repository/tag? This command even shows a short summary of the commands run in each layer. This is very convenient for exploring how an image was made.

`podman history ubi7-change`{{execute}}

Notice that the first image ID (bottom) listed in the output matches the registry.access.redhat.com/ubi7/ubi image. Remember, it is important to build on a trusted base image from a trusted source (aka have provenance or maintain chain of custody). Container repositories are made up of layers, but we often refer to them simply as "container images" or containers. When architecting systems, we must be precise with our language, or we will cause confusion to our end users.
