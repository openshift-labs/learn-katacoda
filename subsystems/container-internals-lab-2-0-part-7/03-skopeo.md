In this step, we are going to do a couple of simple exercises with Skopeo to give you a feel for what it can do. Skopeo doesn't need to interact with the local container storage (overlay2 or devicemapper), it can move directly between registries, between container engine storage, or even directories.

## Remotely Inspecting Images

First, lets start with the use case that kicked off the Skopeo project. Sometimes, it's really convenient to inspect an image remotely before pulling it down to the local cache. This allows us to inspect the metadata of the image and see if we really want to use it, without synchronizing it to the local image cache:

``skopeo inspect docker://registry.fedoraproject.org/fedora``{{execute}}

We can easliy see the "Architecture" and "Os" metadata which tells us a lot about the image. We can also see the labels, which are consumed by most container engines, and passed to the runtime to be constructed as environment variables. By comparison, here's how to see them in a running container:

``podman inspect $(podman create registry.fedoraproject.org/fedora bash)``{{execute}}

## Pulling Images

Like, Podman, Skopeo can be used to pull images down into the local container storage:

``skopeo copy docker://registry.fedoraproject.org/fedora containers-storage:fedora``{{execute}}

But, it can also be used to pull them into a local directory:

``skopeo copy docker://registry.fedoraproject.org/fedora dir:/root/fedora-skopeo``{{execute}}

This has the advantage of not being mapped into our container storage. This can be convenient for security analysis:

``ls -alh /root/fedora-skopeo``{{execute}}

The Config and Image Layers are there, but remember we need to rely on a [Graph Driver](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.kvykojph407z) in a [Container Engine](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.6yt1ex5wfo3l) to map them into a RootFS.

## Moving Between Container Storage (Docker & Podman)

Now, lets look at moving images between Podman and Docker. Once, we have the image stored locally, this is trivial:

``skopeo copy containers-storage:registry.fedoraproject.org/fedora docker-daemon:registry.fedoraproject.org/fedora:latest``{{execute}}

Verify that the repository is now in the Docker Engine cache:

``docker images | grep registry.fedoraproject.org``{{execute}}

This can be useful when testing and getting comfortable with other OCI complaint tools like Podman, Buildah, and Skopeo. Someitmes, you aren't quite ready to let go of what you know.

## Moving Between Container Registries

Finally, lets copy from one registry to another. I have set up a writeable repository under my username (fatherlinux) on quay.io. To do this, you have to use the credentials provided below. Notice, that we use the "--dest-creds" option to authenticate. We can also use the "--source-cred" option to pull from a registry which requires authentication. This tool is very flexible. Designed by engineers, for engineers.

``skopeo copy containers-storage:registry.fedoraproject.org/fedora docker://quay.io/fatherlinux/fedora --dest-creds fatherlinux+fedora:5R4YX2LHHVB682OX232TMFSBGFT350IV70SBLDKU46LAFIY6HEGN4OYGJ2SCD4HI``{{execute}}

This command just synchronized the fedora repository from the Fedora Registry to Quay.io without ever caching it in the local container storage. Very cool right?

## Conclusion

You have a new tool in your toolbelt for sharing and moving containers. Hopefully, you find other uses for Skopeo.
