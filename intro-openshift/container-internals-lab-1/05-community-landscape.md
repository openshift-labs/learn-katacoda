Now that you have a basic understanding of the different daemons that work together to build and manage containers, let's take a quick look at upstream communities. Like Linux before it, OpenShift is really a distribution of Kubernetes that includes a lot of upstream work form many differnet projects. OpenShift pulls all of this together because Kubernetes needs a container runtime, a Linux kernel, etc. Also, the best way to guarantee compatibility is to test and distribute all of these components together.

![Container Libraries](../../assets/intro-openshift/container-internals-lab-1/05-community-landscape.png)


Notice which daemons start which ones. Also, notice that the OpenShift API, Controller and Node processes are actually docker containers. There is a project to containerize all of the foundational daemons including the docker daemon on RHEL Atomic Host.

``ps aux --forest``{{execute}}

Looking at this all working togeter, it's important to realize that this entire toolchain is open source, but different components are driven by different communities. Red Hat leads in all of these communities and brings all of these pieces together with OpenShift.


