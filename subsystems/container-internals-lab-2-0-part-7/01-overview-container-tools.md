In this lab we're going to cover a plethora of container tools available in Red Hat Enteprise Linux (RHEL), including Podman, Buildah, Skopeo, CRIU and Udica. Before we get into the specific tools, it's important to understand how these are tools are provided to the end user in the Red Hat ecosystem.

The RHEL kernel, systemd, and container tools serve as the foundation for both RHEL Server as well as RHEL CoreOS. RHEL Server is a flexible, general purpose operating system which can be customized for many different use cases. On the other hand, RHEL CoreOS is a minimal, purpose built operating system intended to be consumed within automated environments like OpenShift. This lab will specifically cover the tools available in RHEL Server, but much of what you learn is useful in an OpenShift environment because CoreOS is built from the same bits but comes with version specifically built and tested with OpenShift.

Here's a quick overview of how to think about RHEL Server versus RHEL CoreOS:

# ``General Purpose: User -> Podman -> RHEL Server``
# ``OpenShift: User -> Kubernetes API -> Kubelet -> CRI-O -> RHEL CoreOS``

In a RHEL Server environment, the end user will create containers directly on the container host with Podman. In an OpenShift environment, the end user will create containers through the Kubernetes API, not directly on individual hosts in the cluster. 

Now, let's move on to how container tools are packaged in RHEL Server. The launch of RHEL8 introduced the concept of [Application Streams](https://www.redhat.com/en/blog/introduction-appstreams-and-modules-red-hat-enterprise-linux), which provide users with access to the latest versions of software like Python, Ruby, and even container tools. These Application Streams have different, and often shorter life cycles than RHEL (10+ years). Specifically, RHEL8 Server provides users with two types of Application Streams for Container tools:

# Fast: Rolling stream which is updated with new versions of Podman and other tools up to every 12 weeks, and only supported until the next version is released. This stream is for users looking for the latest features in Podman. 
# Stable: Traditional streams released once per year, and supported for 24 months. Once released these streams do not update versions of Podman and other tools, and only provide security fixes. This stream is for users looking to put Podman into production depending on stability.

For a deeper dive, check out [RHEL 8 enables containers with the tools of software craftsmanship](https://www.redhat.com/en/blog/rhel-8-enables-containers-tools-software-craftsmanship-0). Now, let's move on to installing and using these different streams of software. 
