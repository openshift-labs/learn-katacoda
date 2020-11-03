In this step, we are going to do a couple of simple exercises with Skopeo to give you a feel for what it can do. Skopeo doesn't need to interact with the local container storage (.local/share/containers), it can move directly between registries, between container engine storage, or even directories.

## Remotely Inspecting Images

First, lets start with the use case that kicked off the Skopeo project. Sometimes, it's really convenient to inspect an image remotely before pulling it down to the local cache. This allows us to inspect the meta-data of the image and see if we really want to use it, without synchronizing it to the local image cache:

``skopeo inspect docker://registry.fedoraproject.org/fedora``{{execute}}

We can easily see the "Architecture" and "Os" meta-data which tells us a lot about the image. We can also see the labels, which are consumed by most container engines, and passed to the runtime to be constructed as environment variables. By comparison, here's how to see this meta-data in a running container:

``podman run --name meta-data-container -id registry.fedoraproject.org/fedora bash
podman inspect meta-data-container``{{execute}}

## Pulling Images

Like, Podman, Skopeo can be used to pull images down into the local container storage:

``skopeo copy docker://registry.fedoraproject.org/fedora containers-storage:fedora``{{execute}}

But, it can also be used to pull them into a local directory:

``skopeo copy docker://registry.fedoraproject.org/fedora dir:$HOME/fedora-skopeo``{{execute}}

This has the advantage of not being mapped into our container storage. This can be convenient for security analysis:

``ls -alh ~/fedora-skopeo``{{execute}}

The Config and Image Layers are there, but remember we need to rely on a [Graph Driver](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.kvykojph407z) in a [Container Engine](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.6yt1ex5wfo3l) to map them into a RootFS.

## Moving Between Container Storage (Podman & Docker)

First, let's do a little hack to install Docker CE side by side with Podman on RHEL 8. Don't do this on a production system as this will overwrite the version of runc provided by Red Hat:

``yes|sudo rpm -ivh --nodeps --force https://download.docker.com/linux/centos/8/x86_64/stable/Packages/containerd.io-1.3.7-3.1.el8.x86_64.rpm
sudo yum install -y docker-ce``{{execute}}

Now, enable the Docker CE service:

``sudo systemctl enable --now docker``{{execute}}

Now that we have Docker and Podman installed side by side with the Docker daemon running, lets copy an image from Podman to Docker. Since we have the image stored locally in .local/share/containers, it's trivial to copy it to /var/lib/docker using the daemon:

``skopeo copy containers-storage:registry.fedoraproject.org/fedora docker-daemon:registry.fedoraproject.org/fedora:latest``{{execute}}

Verify that the repository is now in the Docker CE cache:

``docker images | grep registry.fedoraproject.org``{{execute}}

This can be useful when testing and getting comfortable with other OCI complaint tools like Podman, Buildah, and Skopeo. Sometimes, you aren't quite ready to let go of what you know so having them side by side can be useful. Remember though, this isn't supported because it replaces the runc provided by Red Hat.

## Moving Between Container Registries

Finally, lets copy from one registry to another. I have set up a writeable repository under my username (fatherlinux) on quay.io. To do this, you have to use the credentials provided below. Notice, that we use the "--dest-creds" option to authenticate. We can also use the "--source-cred" option to pull from a registry which requires authentication. This tool is very flexible. Designed by engineers, for engineers.

``skopeo copy docker://registry.fedoraproject.org/fedora docker://quay.io/fatherlinux/fedora --dest-creds fatherlinux+fedora:5R4YX2LHHVB682OX232TMFSBGFT350IV70SBLDKU46LAFIY6HEGN4OYGJ2SCD4HI``{{execute}}

This command just synchronized the fedora repository from the Fedora Registry to Quay.io without ever caching it in the local container storage. Very cool right?

Finally, exit the ''rhel'' user because we need root for the next lab:

``exit``{{execute}}

## Conclusion

You have a new tool in your tool belt for sharing and moving containers. Hopefully, you find other uses for Skopeo.
