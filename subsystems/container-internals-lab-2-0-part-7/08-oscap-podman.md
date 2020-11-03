In this lab we're going to demonstrate using the [oscap-podman](https://github.com/OpenSCAP/openscap/blob/master/utils/oscap-podman) command to verify the security of the [Red Hat Universal Base Image](https://www.redhat.com/en/blog/introducing-red-hat-universal-base-image). Red Hat UBI is a rock solid, freely distributable container base image created by Red Hat and build on RHEL bits (see also: [Comparison of Container Images](http://crunchtools.com/comparison-linux-container-images/). UBI is rebuilt every six weeks or every time there is a Critical or Important [CVE](https://www.redhat.com/en/topics/security/what-is-cve)(Common Vulnerabilities and Exposures) patched and is the foundation for all containerized products at Red Hat. See also [UBI FAQ](https://developers.redhat.com/articles/ubi-faq).

While UBI is a great foundation, some of us are skeptical and like our vendors to show their work. Luckily, the Red Hat Product Security Team does just that using OVAL data. For those that have never heard of this, OVAL stands for The Open Vulnerability and Assessment Language project, which maintained by The MITRE Corporation (same group that does CVEs), an international, information security effort that promotes open and publicly available security content, and seeks to standardize the transfer of this information across the entire spectrum of security tools and services. Red Hat Product Security helps customers evaluate and manage risk by tracking and investigating all security issues affecting Red Hat customers and providing timely and concise patches and security advisories via the Red Hat Customer Portal creating and supporting OVAL patch definitions, providing a machine-readable versions of our security advisories. This allows OVAL-compatible tools to test for the presence of vulnerabilities for which Red Hat has released security updates that could be applied to the system. 

You can see that data here: https://www.redhat.com/security/data/oval/v2/RHEL8/

Before we begin the lab, download the latest OVAL data from Red Hat Product Security:

``wget https://www.redhat.com/security/data/oval/v2/RHEL8/rhel-8.oval.xml.bz2``{{execute}}

Now, we're going to use the oscap-podman tool to consume the data and compare some versions of the Red Hat Universal Base Image which we have stored locally in the Podman cache. Container images age like cheese, not like wine. Older container images which haven't been rebuilt will build up CVEs over time. From the Red Hat Ecosystem Catalog, we can see that the [UBI 8.0-126 image](https://catalog.redhat.com/software/containers/ubi8/ubi/5c359854d70cc534b3a3784e?tag=8.0-126&push_date=1560882955000) which was build June 11th, 2019 has a grade of F and at the time of this writing had 3 important security vulnerabilities.

Check it out here: [UBI 8.0-126 image](https://catalog.redhat.com/software/containers/ubi8/ubi/5c359854d70cc534b3a3784e?tag=8.0-126&push_date=1560882955000)

Now, let's take a more detailed look, using the oscap-podman command:

``oscap-podman registry.access.redhat.com/ubi8/ubi:8.0-126 oval eval --report ./html/ubi-8.0-126-report.html rhel-8.oval.xml.bz2``{{execute}}

This will create a report. We've already set up a web server (in a container) so that you can quickly look at the report here:

https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/ubi-8.0-126-report.html

Notice that there are many orange lines displaying the CVEs/RHSAs. If you built and ran an application on this very old container image, it would be exposed to these vulnerabilities. Now, let's scan the latest version of UBI provided by Red Hat:

``oscap-podman registry.access.redhat.com/ubi8/ubi:latest oval eval --report ./html/ubi-latest-report.html rhel-8.oval.xml.bz2``{{execute}}

Look at the new report: 

* https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/ubi-latest-report.html

## Conclusions

In general you should almost never see any unapplied patches in this latest build of UBI. If you do, it's like a small window between the time that Red Hat Product Security has issued a CVE, and our product team has rebuilt and published the UBI image. The oscap-podman command allows you to verify this and is useful in "trust but verify" operations like CI/CD system tests. For more information and deeper dive on OSCAP-Podman, check out this great video by Brian Smith: [Scanning Containers for Vulnerabilities on RHEL 8.2 With OpenSCAP and Podman](https://www.youtube.com/watch?v=nQmIcK1vvYc)
