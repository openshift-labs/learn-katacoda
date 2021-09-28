In this exercise, we will take a look at what's inside the container image. Java is particularly interesting because it uses glibc, even though most people don't realize it. We will use the ldd command to prove it, which shows you all of the libraries that a binary is linked against. When a binary is dynamically linked (libraries loaded when the binary starts), these libraries must be installed on the system, or the binary will not run. In this example, in particular, you can see that getting a JVM to run with the exact same behavior requires compiling and linking in the same way. Stated another way, all Java images are not created equal:

``podman run -it registry.access.redhat.com/jboss-eap-7/eap70-openshift ldd -v -r /usr/lib/jvm/java-1.8.0-openjdk/jre/bin/java``{{execute}}

Notice that dynamic scripting languages are also compiled and linked against system libraries:

``podman run -it registry.access.redhat.com/ubi7/ubi ldd /usr/bin/python``{{execute}}

Inspecting a common tool like "curl" demonstrates how many libraries are used from the operating system. First, start the RHEL Tools container. This is a special image that Red Hat releases with all of the tools necessary for troubleshooting in a containerized environment. It's rather large, but quite convenient:

``podman run -it registry.access.redhat.com/rhel7/rhel-tools bash``{{execute}}

Take a look at all of the libraries curl is linked against:

``ldd /usr/bin/curl``{{execute}}

Let's see what packages deliver those libraries. It seems as if it's both OpenSSL and the Network Security Services libraries. When there is a new CVE discovered in either OpenSSL or NSS, a new container image will need to be built to patch it:

``rpm -qf /lib64/libssl.so.10``{{execute}}

``rpm -qf /lib64/libssl3.so``{{execute}}

Exit the rhel-tools container:

``exit``{{execute}}


It's a similar story with Apache and most other daemons and utilities that rely on libraries for security or deep hardware integration:

``podman run -it registry.access.redhat.com/rhscl/httpd-24-rhel7 bash``{{execute}}

Inspect mod_ssl Apache module:

``ldd /opt/rh/httpd24/root/usr/lib64/httpd/modules/mod_ssl.so``{{execute}}

Once again, we find a library provided by OpenSSL:

``rpm -qf /lib64/libcrypto.so.10``{{execute}}

Exit the httpd24 container:

``exit``{{execute}}

What does this all mean? Well, it means you need to be ready to rebuild all of your container images any time there is a security vulnerability in one of the libraries inside it.
