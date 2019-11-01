The goal of this exercise is to understand the basics of trust when it comes to [Registry Servers](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.4cxnedx7tmvq) and [Repositories](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.20722ydfjdj8). This requires quality and provenance - this is just a fancy way of saying that:

1. You must download a trusted thing
2. You must download from a trusted source

Each of these is necesary, but neither alone is sufficient. This has been true since the days of downloading ISO images for Linux distros. Whether evaluating open source libraries or code, prebuilt packages (RPMs or Debs), or [Container Images](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.dqlu6589ootw), we must:

1. determine if we trust the image by evaluating the quality of the code, people, and organizations involved in the project. If it has enough history, investment, and actually works for us, we start to trust it.

2. determine if we trust the registry, by understanding the quality of its relationship with the trusted project - if we download something from the offical GitHub repo, we trust it more than from a fork by user Haxor5579. This is true with ISOs from mirror sites and with image repositories built by people who aren't affiliated with the underlying code or packages.

There are [plenty of examples](https://www.infoworld.com/article/3289790/application-security/deep-container-inspection-what-the-podman-hub-minor-virus-and-xcodeghost-breach-can-teach-about-con.html) where people ignore one of the above and get hacked.  In a previous lab, we learned how to break the URL down into registry server, namespace and repository. 

## Trusted Thing

From a security perspective, it's much better to remotely inspect and determine if we trust an image before we download it, expand it, and cache it in the local storage of our container engine. Everytime we download an image, and expose it to the graph driver in the container engine, we expose ourselves to potential attack. First, let's do a remote inspect with Skopeo (can't do that with docker because of the client/server nature):

`skopeo inspect docker://registry.fedoraproject.org/fedora`{{execute}}

Examine the JSON. There's really nothing in there that helps us determine if we trust this repository. It "says" it was created by the Fedora project ("vendor": "Fedora Project") but we have no idea if that is true. We have to move on to verifying that we trust the source, then we can determin if we trust the thing.

## Trusted Source

There's a lot of talk about image signing, but the reality is, most people are not verifying container images with signatures. What they are actually doing is relying on SSL to determine that they trust the source, then inferring that they trust the container image. Lets use this knowledge to do a quick evaluation of the official Fedora registry:

`curl -I https://registry.fedoraproject.org`{{execute}}

Notice that the SSL certificate fails to pass muster. That's because the DigiCert root CA certificate is not in /etc/pki on this CentOS lab box. On RHEL and Fedora this certficate is distributed by default and the SSL certificate for registry.fedoraproject.org passes muster. So, for this lab, you have to trust me, I tested it :-) If you were on a Fedora or Red Hat Enterprise Linux box with the right keys, the output would have looked like this:

`HTTP/2 200 
date: Thu, 25 Apr 2019 17:50:25 GMT
server: Apache/2.4.39 (Fedora)
strict-transport-security: max-age=31536000; includeSubDomains; preload
x-frame-options: SAMEORIGIN
x-xss-protection: 1; mode=block
x-content-type-options: nosniff
referrer-policy: same-origin
last-modified: Thu, 25 Apr 2019 17:25:08 GMT
etag: "1d6ab-5875e1988dd3e"
accept-ranges: bytes
content-length: 120491
apptime: D=280
x-fedora-proxyserver: proxy10.phx2.fedoraproject.org
x-fedora-requestid: XMHzYeZ1J0RNEOvnRANX3QAAAAE
content-type: text/html`

Even without the root CA certificate installed, we can discern that the certicate is valid and managed by Red Hat, which helps a bit:

`curl 2>&1 -kvv https://registry.fedoraproject.org | grep subject`{{execute}}

Think carefully about what we just did. Even visually validating the certificate gives us some minimal level of trust in this registry server. In a real world scenario, rememeber that it's the container engine's job to check these certificates. That means that Systems Administrators need to distribute the appropriate CA certificates in production. Now that we have inspected the certificate, we can safely pull the trusted repository (because we trust the Fedora project built it right) from the trusted registry server (because we know it is managed by Fedora/Red Hat):

`podman pull registry.fedoraproject.org/fedora`{{execute}}

Now, lets move on to evaluate some trickier repositories and registry servers...

