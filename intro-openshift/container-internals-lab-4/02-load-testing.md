Now we are going to inspect the different parts of the URL that you pull. The most common command is something like this, where only the repository name is specified:

``docker inspect rhel7``{{execute}}

But, what's really going on? Well, similar to DNS, the docker command line is resolving the full URL and TAG of the repository on the registry server. The following command will give you the exact same results:

``docker inspect registry.access.redhat.com/rhel7/rhel:latest``{{execute}}

You can run any of the following commands and you will get the exact same results as well:

``docker inspect registry.access.redhat.com/rhel7/rhel:latest``{{execute}}

``docker inspect registry.access.redhat.com/rhel7/rhel``{{execute}}

``docker inspect registry.access.redhat.com/rhel7:latest``{{execute}}

``docker inspect registry.access.redhat.com/rhel7``{{execute}}

``docker inspect rhel7/rhel:latest``{{execute}}

``docker inspect rhel7/rhel``{{execute}}

Now, let's build another image, but give it a tag other than "latest":

``docker build -t registry.access.redhat.com/rhel7/rhel:test ~/assets/exercise-01/``{{execute}}

Now, notice there is another tag

``docker run --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz images -t``{{execute}}

Now try the resolution trick again. What happened?

``docker inspect rhel7:test``{{execute}}

It failed, but why? Try again with a more complete URL:

``docker inspect rhel7/rhel:test``{{execute}}

Notice that the DNS-like resolution only works with the latest tag. You have to specify the namespace and the repository with other tags. If you test long enough, you will find many other caveats to namespace, repository and tag resolution, so be careful. Typically, it's best to use the full URL. Remember this when building scripts. Containers seem deceptively easy, but you need to pay attention to details.

