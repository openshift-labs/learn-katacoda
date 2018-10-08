The goal of this exercise is to learn how to evaluate a [Container Image](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.dqlu6589ootw) and the [Registry Server](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.4cxnedx7tmvq) from which you get it. 

First, lets start what we already know, there is often a full functioning Linux distro inside a container image. That's because it's useful to leverage existing packages and the dependency tree already created for it. This is true whether running on bare metal, in a virtual machine, or in a container image. It's also important to consider the quality, frequency, and ease of consuming updates in the container image.

To analyze the quality, we are going to leverage existing tools - which is another advantage of consuming a container image which leverages a Linux distro. To demonstrate, let's examine an old, old Red Hat Enterprise Linux image. The following command will show all errata which is available to be installed for this particular container image:

``docker run -it registry.access.redhat.com/rhel7:7.4-105 yum updateinfo security``{{execute}}

Notice there are a bunch of unapplied security updates. Now, lets take a look at the how Red Hat scores this very old image. Perhaps, we could have saved ourselves from time, but picking a newer image:

[Red Hat Enterprise Linux 7.4-105 Base Image](https://access.redhat.com/containers/#/registry.access.redhat.com/rhel7/images/7.4-105)

IMAGE TBD
![Containers Are Linux](../../assets/subsystems/container-internals-lab-2-0-part-3/01-evaluating-trust.png)

Poke around in the Red Hat Container Catalog and notice how this particulare image has a warning associated. That's because container images age like cheese, not like wine. Trust is termporal and older container images age just like servers which are rarely or never patched. 

Now take a look at the Container Health Index scoring for each tag that is available: 

[Red Hat Enterprise Linux Base Image - All Tags](https://access.redhat.com/containers/?tab=tags#/registry.access.redhat.com/rhel7)

Notice, that the newer the tag, the better the letter grade. The Red Hat Container Catalog and Container Health Index clearly show you that the newer images have a less vulnerabiliites and hence have a better letter grade. To fully understand the scoring criteria, check out [Knowledge Base Article](https://access.redhat.com/articles/2803031).

Finally, let's do the same test we did before, but on a newer container image:

``docker run -it registry.access.redhat.com/rhel7:7.4-105 yum updateinfo security``{{execute}}

Notice that there are no available errata. Now, let's take a look at a couple of other registries:

- [registry.fedoraproject.org](https://registry.fedoraproject.org/)
- [https://hub.docker.com/explore/](https://hub.docker.com/explore/)
- [https://bitnami.com/containers](https://bitnami.com/containers)

Knowing what you know now:
- How would you rate your trust in these registries? By brand, tooling, image quality?
- How would you analyze these container images to determine if you trust them? 
- How would you rate the tooling they provide you to analyze images?

These questions seem easy, but their really not. It really makes you revisit what it means to "trust" a acontainer image...
