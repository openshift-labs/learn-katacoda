Now we are going to inspect the different parts of the URL that you pull. The most common command is something like this, where only the repository name is specified:

``podman inspect ubi7``{{execute}}

But, what's really going on? Well, similar to DNS, the podman command line is resolving the full URL and TAG of the repository on the registry server. The following command will give you the exact same results:

``podman inspect registry.access.redhat.com/ubi7/ubi:latest``{{execute}}

You can run any of the following commands and you will get the exact same results as well:

``podman inspect registry.access.redhat.com/ubi7/ubi:latest``{{execute}}

``podman inspect registry.access.redhat.com/ubi7/ubi``{{execute}}

``podman inspect registry.access.redhat.com/ubi7:latest``{{execute}}

``podman inspect registry.access.redhat.com/ubi7``{{execute}}

``podman inspect ubi7/ubi:latest``{{execute}}

``podman inspect ubi7/ubi``{{execute}}

Now, let's build another image, but give it a tag other than "latest":

``podman build -t registry.access.redhat.com/ubi7/ubi:test ~/labs/lab2-step1/``{{execute}}

Now, notice there is another tag

``podman run --rm --privileged -v /var/run/podman.sock:/var/run/podman.sock nate/dockviz images -t``{{execute}}

Now try the resolution trick again. What happened?

``podman inspect ubi7:test``{{execute}}

It failed, but why? Try again with a more complete URL:

``podman inspect ubi7/ubi:test``{{execute}}

Notice that the DNS-like resolution only works with the latest tag. You have to specify the namespace and the repository with other tags. If you test long enough, you will find many other caveats to namespace, repository and tag resolution, so be careful. Typically, it's best to use the full URL. Remember this when building scripts. Containers seem deceptively easy, but you need to pay attention to details.

