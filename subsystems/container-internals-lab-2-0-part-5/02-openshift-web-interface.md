In the last step, you created a multi-tier web application. Now, log into the OpenShift web interface which is a convenient place to monitor the state, and troubleshoot things when they go wrong. You can even get a debug terminal into a Pod to troubleshoot if it crashes. This can help you figure out why it crashed. This shouldn't happen in this lab, but as you build applications it surely will. Also, feel free to delete a pod and see what happens. Kubernetes will see that the defined state and actual state no longer match and will recreate it. This is useful when things are taking too long :-)

* Username: `admin`{{copy}}
* Password: `admin`{{copy}}
* Console: [here](https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/default/overview)

Here are some useful locations to investigate what is happening. The "Events" section is useful early in the Pod creation process, when its being scheduled in the cluster and then when the container image is being pulled. Later in the process when a Pod is crashing because of something in the container image itself, its useful to watch the terminal output in the "Logs" section. It can also be useful to run commands live in a Terminal. Sometimes a Pod won't start, so it's useful poke around with using the "Debug in Terminal" section. Get a feel in the following areas of the interface.

First check out the MySQL Pod:

- Applications -> Pods -> mysql-<id> -> Details
- Applications -> Pods -> mysql-<id> -> Events 
- Applications -> Pods -> mysql-<id> -> Logs
- Applications -> Pods -> mysql-<id> -> Terminal

Do the same for Wordpress:

- Applicaitons -> Pods -> wordpress-<id> -> Details
- Applicaitons -> Pods -> wordpress-<id> -> Events
- Applicaitons -> Pods -> wordpress-<id> -> Logs
- Applicaitons -> Pods -> wordpress-<id> -> Terminal

Once you've spent some time in the web interface, move on to the next lab.
