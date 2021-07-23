In this lab, we are going to focus on how [Container Enginers](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.6yt1ex5wfo3l) cache [Repositories](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.20722ydfjdj8) on the container host. There is a little known or understood fact - whenever you pull a container image, each layer is cached locally, mapped into a shared filesystem - typically overlay2 or devicemapper. This has a few implications. First, this means that caching a container image locally has historically been a root operation. Second, if you pull an image, or commit a new layer with a password in it, anybody on the system can see it, even if you never push it to a registry server.


Now, let's take a look at Podman container engine. It pulls OCI compliant, docker compatible images:

``podman info  | grep -A4 graphRoot``{{execute}}

First, you might be asking yourself, [what the heck is d_type?](https://linuxer.pro/2017/03/what-is-d_type-and-why-docker-overlayfs-need-it/). Long story short, it's filesystem option that must be supported for overlay2 to work properly as a backing store for container images and running containers. Now, take a look at the actuall storage being used by Podman:

``tree /var/lib/containers/storage``{{execute}}

Now, pull an image and verify that the files are just mapped right into the filesystem:

``podman pull registry.access.redhat.com/ubi7/ubi
cat $(find /var/lib/containers/storage | grep redhat-release | tail -n 1)``{{execute}}

With both Docker and Podman, as well as most other container engines on the planet, image layers are mapped one for one to some kind of storage, be it thinp snapshots with devicemapper, or directories with overlay2. 

This has implications on how you move container images from one registry to another. First, you have to pull it and cache it locally. Then you have to tag it with the URL, Namespace, Repository and Tag that you want in the new regsitry. Finally, you have to push it. This is a convoluted mess, and in a later lab, we will investigate a tool called Skopeo that makes this much easier.

For now, you understand enough about registry servers, repositories, and how images are cached locally. Let's move on.

