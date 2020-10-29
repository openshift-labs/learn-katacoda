## The Image Specification

First, lets take a quick look at the contents of a container repository once it's uncompressed. We will use a utility you may have seen before called Podman. The syntax is nearly identical to Docker. Create a working directory for our experiment, then make sure the fedora image is cached locally:

``mkdir fedora
cd fedora
podman pull fedora``{{execute}}

Now, export the image to a tar, file and extract it:
``podman save -o fedora.tar fedora
tar xvf fedora.tar``{{execute}}

Finally, let's take a look at three important parts of the container repository - these are the three major pieces that can be found in a container repository when inspected:

1. Manifest - Metadata file which defines layers and config files to be used.
2. Config - Config file which is consumed by the container engine. This config file is combined with user input specified at start time, as well as defaults provided by the container engine to create the runtime Config.json. This file is then handed to the continer runtime (runc) which communicates with the Linux kernel to start the container.
3. Image Layers - tar files which are typically typically gzipped. They are merged together when the container is run to create a root file system which is mounted.

In the Manifest, you should see one or more Config and Layers entries:

``cat manifest.json | jq``{{execute}}

In the Config file, notice all of the meta data that looks strikingly similar to command line options in Docker & Podman:

``cat $(cat manifest.json | awk -F 'Config' '{print $2}' | awk -F '["]' '{print $3}') | jq``{{execute}}

Each Image Layer is just a tar file. When all of the necessary tar files are extracted into a single directory, they can be mounted into a container's mount namespace:

``tar tvf $(cat manifest.json | awk -F 'Layers' '{print $2}' | awk -F '["]' '{print $3}')``{{execute}}

The take away from inspecting the three major parts of a container repository is that they are really just the wittiest use of tarballs ever invented. Now, that we understand what is on disk, lets move onto the runtime.
