The goal of this exercise is to understand the basics of trust when it comes to [Registry Servers](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.4cxnedx7tmvq) and [Repositories](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.20722ydfjdj8). This requires quality and provenance - this is just a fancy way of saying that:

1. You must download a trusted thing
2. You must download from a trusted source

Each of these is necesary, but neither alone is sufficient. This has been true since the days of downloading ISO images for Linux distros. Whether evaluating open source libraries or code, prebuilt packages (RPMs or Debs), or [Container Images](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.dqlu6589ootw), we must:

1. determine if we want to extend our trust by evaluating the quality of the code, people, and organizations involved in the project. If it has enough history, investment, and actually works for us, we start to trust it.

2. determine if the source is trustworthy, by understanding the quality of its relationship with the trusted project - if we download something from the offical GitHub repo, we trust it more than from a fork by user Haxor5579. The same is true with ISos from mirror sites. The exact same thing is true with container images built by projects or teams that aren't affiliated with the underlying code.

There are [plenty of examples](https://www.infoworld.com/article/3289790/application-security/deep-container-inspection-what-the-docker-hub-minor-virus-and-xcodeghost-breach-can-teach-about-con.html) where people ignore one of the above and get hacked.  In the lab on container images, we learned how to break the URL down into registry server, namespace and repository. As a quick introduction, lets do a quick evaluation of the official fedora container image:

``curl -kIvv https://registry.fedoraproject.org``{{execute}}

Notice that the SSL certificate fails to pass muster. That's because the DigiCert root CA certificate is not in /etc/pki on this CentOS lab box. On RHEL and Fedora this certficate is distributed by default and the SSL certificate for registry.fedoraproject.org passes muster. So, for this lab, you have to trust me, I tested it :-) Even without the root CA certificat installed, we can discern that the certicate is valid and managed by Red Hat. 

Think carefully about what we just did. Even simply looking at the certificate gives us some minimal level of trust in this registry server. In a real world scenario, rememeber that it's the container engine's job to check these certificates. That means that admins need to distribute the appropriate CA certificates in productoin. Now that we have inspected the certificate, we can safely pull the trusted repository (because we trust the Fedora project built it right) from the trusted registry server (because we know it is managed by Fedora/Red Hat):

``docker pull registry.fedoraproject.org/fedora``{{execute}}

Now, lets move on to evaluate some trickier repositories and registry servers...
