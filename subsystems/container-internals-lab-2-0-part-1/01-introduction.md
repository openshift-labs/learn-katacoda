If you understand Linux, you probably already no 85% of what you need to know to understand containers. If you understand how processes (ps), mounts (mount), networks (ip addr), shells (bash) and daemons (httpd, mysqld) work then you just need to understand a few extra primitives to get you over the line to truly architecting solutions with containers. After teaching this for years, we have boiled this down to an analysis of four new basic primitives:

* Container Images
* Container Registres
* Container Hosts
* Container Orchestration

All of the things that you know today still apply, from security & performance, to storage & networking, the same concepts apply. Now, let's lightly dig into each of the four new primitives...
 
