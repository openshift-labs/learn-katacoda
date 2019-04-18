If you understand Linux, you probably already no 85% of what you need to know to understand containers. If you understand how processes (ps), mounts (mount), networks (ip addr), shells (bash) and daemons (httpd, mysqld) work then you just need to understand a few extra primitives to get you over the line to truly architecting solutions with containers. After teaching this for years, we have boiled this down to an analysis of four new basic primitives:

* [Container Images](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.dqlu6589ootw)
* [Container Registres](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.4cxnedx7tmvq)
* [Container Hosts](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.8tyd9p17othl)
* [Container Orchestration](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.6yt1ex5wfo66)

All of the things that you know today still apply, from security & performance, to storage & networking, the same concepts apply. Now, let's lightly dig into each of the four new primitives...

![Container Libraries](../../assets/subsystems/container-internals-lab-2-0-part-1/02-container-image-host-supportability.png) 
