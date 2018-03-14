We need to install `siege` to perform load test. [Siege](https://www.joedog.org/siege-home/) Siege is an open source regression test and benchmark utility. It can stress test a single URL with a user defined number of simulated users, or it can read many URLs into memory and stress them simultaneously.

First lets download latest siege binary RPMs.

`wget -c https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/s/siege-4.0.2-2.el7.x86_64.rpm https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/l/libjoedog-0.1.2-1.el7.x86_64.rpm -P installation/`{{execute T1}}

Now let's install those RPM files.

`rpm -ivh installation/*.rpm`{{execute T1}}

Now, try the siege command: `siege --version`{{execute T1}}
