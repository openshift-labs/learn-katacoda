The goal of this exercise is to understand the basics of trust when it comes to [Registry Servers](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.4cxnedx7tmvq) and [Repositories](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.20722ydfjdj8). This requires quality and provenance - this is just a fancy way of saying that:

1. You must download a trusted thing
2. You must download from a trusted source

Each of these is necesary, but neither alone is sufficient. This has been true since the days of downloading ISO images for Linux distros. Whether evaluating open source projects, prebuilt packages (RPMs or Debs), or [Container Images](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.dqlu6589ootw), we learn to:

1. We determine if we want to extend our trust by evaluating the quality of the code, people, and organizations involved in the project. If it has enough history, investment, and actually works, we start to trust it.

2. We determine if the source is trustworthy, by understanding the quality of its relationship with the trusted project - if we download something from the offical GitHub repo, we trust it more than from a fork by user Haxor5579.

There are [plenty of examples](https://www.infoworld.com/article/3289790/application-security/deep-container-inspection-what-the-docker-hub-minor-virus-and-xcodeghost-breach-can-teach-about-con.html) where people ignore one of the above and get hacked. As a quick introduction, lets do a quick evaluation of the official fedora container image:

The full URL is:

``https://registry.fedoraproject.org/fedora``

In the lab on Container Images, we learned how to break the URL down into registry server, namespace and repository. First, lets check the validity of the registry server:

``curl -Ivv https://registry.fedoraproject.org``{{executue}}''

Notice that the SSL cert looks trustworthy. The certicate is valid and managed by Red Hat. Now, we can pull the repository because we know its the official Fedora container repository on the official Fedora registry server:

``docker pull https://registry.fedoraproject.org/fedora``{{executue}}''

We can do this same thing with Podman:

``podman pull https://registry.fedoraproject.org/fedora``{{executue}}''

Now, lets move on to evaluate some trickier repositories...
