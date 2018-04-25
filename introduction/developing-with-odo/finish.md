Congratulations! You just learned the basics of using the `odo` tool to manage application components on the OpenShift Container Platform.

## Feedback

This tutorial introduces a tool under very active development. `Odo` intends to group underlying API and platform features into simple concepts and steps that match existing developer workflows. We'd love to know how you well you think `odo` meets those goals. If you'd like to provide feedback, we welcome your input and we've included a quick survey right inside your sample application's `frontend` component. You can access the survey at the URL:

**https://frontend-myproject.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/form.php**.

## What's next?

We hope `odo` helps you conveniently access all the power OpenShift has to offer, and that these first steps leave you eager to learn more. https://learn.openshift.com has other tutorials from basic to advanced that offer a real cluster to learn on, just like this scenario. It's also easy to run your own OpenShift cluster locally, or to leave infrastructure management to Red Hat experts by using a hosted OpenShift.

Here are some of the ways you can get your own OpenShift cluster:

### Minishift

Minishift is a complete OpenShift environment inside a virtual machine that runs on your local system. Minishift supports Windows, MacOS, and Linux operating systems. To find out more about minishift, visit http://www.openshift.org/vm.

### *oc cluster up*

*oc cluster up* is a command provided by the `oc` OpenShift API client tool. It configures and runs an OpenShift environment on the Docker container runtime running on your operating system. It supports Windows, MacOS, and the Linux operating systems. For more information, visit https://github.com/openshift/origin/blob/master/docs/cluster_up_down.md.

Advance users of *oc cluster up* often drive it with the *oc cluster wrapper*, which provides profiles for managing multiple OpenShift environments, streamlined management of clusters' persistent volumes, and other features that simplifying creating useful OpenShift clusters.
Check out the official git repository at https://github.com/openshift-evangelists/oc-cluster-wrapper for more information.

### OpenShift Online

The OpenShift team provides a hosted, managed environment that frees developers from worrying about infrastructure. OpenShift Online includes a free *Starter* tier for developing and testing applications on OpenShift. OpenShift Online Pro provides scalability for production deployments at competitive monthly rates in a multi-tenant environment. Find details about OpenShift Online, and sign up for free, at https://www.openshift.com/pricing/.

### OpenShift Dedicated

For the highest production requirements, Red Hat hosts and manages dedicated OpenShift instances available only to your organization. OpenShift Dedicated is ideal for larger teams that want the scale and velocity benefits of container cluster orchestration without having to sweat the details of deploying and maintaining secure, reliable infrastructure. To find out more, visit https://www.openshift.com/dedicated/.
