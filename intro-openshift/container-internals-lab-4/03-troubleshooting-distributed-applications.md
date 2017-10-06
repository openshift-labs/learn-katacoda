In this exercise we will take a look at what's inside the container image. Java is particularly interesting because it uses glibc. The ldd command shows you all of the libraries that a binary is linked against. These libraries have to be on the system, or the binary will not run. In this example, you can see that getting a JVM to run in a particular container, with the exact same behavior, requries having it compiled and linked in the same way.

``docker run -it registry.access.redhat.com/jboss-eap-7/eap70-openshift ldd -v -r /usr/lib/jvm/java-1.8.0-openjdk/jre/bin/java``{{execute}}

Notice that dynamic scripting languages are also compiled and linked against system libraries:

``docker run -it rhel7 ldd /usr/bin/python``{{execute}}

Inspecting a common tool like "curl" demonstrates how many libraries are used from the operating system. First, start the RHEL Tools container. This is a special image which Red Hat releases with all of the tools necessary for troubleshooting in a containerized environment. It's rather large, but quite convenient:

``docker run -it rhel7/rhel-tools bash``{{execute}}

Take a look at all of the libraries curl is linked against:

``ldd /usr/bin/curl``{{execute}}

Let's see what packages deliver those libraries? Both, OpenSSL, and the Network Security Services libraries. When there is a new CVE discovered in either nss or oepnssl, a new container image will need built to patch it.

``rpm -qf /lib64/libssl.so.10``{{execute}}

``rpm -qf /lib64/libssl3.so``{{execute}}

Exit the rhel-tools container:

``exit``{{execute}}


It's a similar story with Apache and most other daemons and utilities that rely on libraries for security, or deep hardware integration:

``docker run -it registry.access.redhat.com/rhscl/httpd-24-rhel7 bash``{{execute}}

Inspect mod_ssl Apache module:

``ldd /opt/rh/httpd24/root/usr/lib64/httpd/modules/mod_ssl.so``{{execute}}

Once again we find a library provided by OpenSSL:

``rpm -qf /lib64/libcrypto.so.10``{{execute}}

Exit the httpd24 container:

``exit``{{execute}}

What does this all mean? Well, it means you need to be ready to rebuild all of your container images any time there is a security vulnerability in one of the libraries inside one of your container images...
