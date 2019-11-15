One of the properties of container images is that they are immutable. That is, although you can make changes to the local container filesystem of a running image, the changes are not permanent. When that container is stopped, any changes are discarded. When a new container is started from the same container image, it reverts back to what was originally built into the image.

Although any changes to the local container filesystem are discarded when the container is stopped, it can sometimes be convenient to be able to upload files into a running container. One example of where this might be done is during development and a dynamic scripting language is being used. By being able to modify code in the container, you can modify the application to test changes before rebuilding the image.

In addition to uploading files into a running container, you might also want to be able to download files. During development these may be data files or log files created by the application.

In this course you will learn how to transfer files between your local machine and a running container. You will also learn how you can set up live synchronisation to enable you to make changes to code on your local machine and have the result immediately used by the application running in the container without you needing to manually copy them.

You will be using just the ``oc`` command line tool in this exercise.