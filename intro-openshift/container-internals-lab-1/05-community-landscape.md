Now that you have an understanding of the different daemons, take a look at all of it together. Notice which daemons start which ones. Also, notice that the OpenShift API, Controller and Node processes are actually docker containers. There is roadmap to containerize the docker daemon on RHEL Atomic Host in the comming months as well.

``ps aux --forest``{{execute}}
