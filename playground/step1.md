## Status Check
`oc status`{{execute}}

`oc login -u system:admin https://[[HOST_IP]]:8443`{{execute}}

`oc get nodes`{{execute}}

## Deploy

`oc create -f hello-pod.json`{{execute}}

`oc get pod hello-openshift`{{execute}}

`ip=$(oc get pod hello-openshift -o yaml |grep podIP | awk '{split($0,a,":"); print a[2]}'); echo $ip`{{execute}}

`curl $ip:8080`{{execute}}

## Dashboard

Dashboard at https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com

Interested in writing your own OpenShift scenarios and demos? Visit [www.katacoda.com/teach](http://www.katacoda.com/teach)
