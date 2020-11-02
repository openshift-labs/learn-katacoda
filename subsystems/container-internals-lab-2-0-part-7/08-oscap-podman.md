

https://www.redhat.com/security/data/oval/v2/RHEL8/

Download the meta-data from Red Hat:

``wget https://www.redhat.com/security/data/oval/v2/RHEL8/rhel-8.oval.xml.bz2``{{execute}}


First, scan an older image which has unapplied Red Hat Security Advisory (RHSA) patches:

``oscap-podman registry.access.redhat.com/ubi8/ubi:8.0-126 oval eval --report ./html/ubi-8.0-126-report.html rhel-8.oval.xml.bz2``{{execute}}

Look at the report:

https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/ubi-8.0-126-report.html

Now, let's scan the latest version of UBI provided by Red Hat:

``oscap-podman registry.access.redhat.com/ubi8/ubi:latest oval eval --report ./html/ubi-8.8-126-report.html rhel-8.oval.xml.bz2``{{execute}}

Look at the report: 

https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/ubi-latest-report.html


For more information and deeper dive on OSCAP-Podman, check out this great video by Brian Smith: [Scanning Containers for Vulnerabilities on RHEL 8.2 With OpenSCAP and Podman](https://www.youtube.com/watch?v=nQmIcK1vvYc)
