The goal of this exercise is to understand the difference between base images and multi-layered images (repositories). Also, try to understand the difference between an image layer and a repository.

First, let's take a look at some base images. We will use the docker history command to inspect all of the layers in these repositories. Notice that these container images have no parent layers. These are base images and they are designed to be built upon.

``docker history rhel7``{{execute}}

``docker history rhel7-atomic``{{execute}}

Now, build a multi-layered image:

``docker build -t rhel7-change ~/assets/exercise-01/``{{execute}}

Do you see the newly created rhel7-change image?

``docker images``{{execute}}

Can you see all of the layers that make up the new image/repository? This command even shows a short summary of the commands run in each layer. This is very convenient for exploring how an image was made.

``docker history rhel7-change``{{execute}}

Now run the "dockviz" command. What does this command show you? What's the parent image of the rhel7-change image? It is important to build on a trusted base image from a trusted source (aka have provenance or maintain chain of custody).

``docker run --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz images -t``{{execute}}
