``curl -k https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/robots.txt``{{execute}}

``oc rsync robotos.txt $POD:/opt/app-root/src/static/``{{execute}}

``curl -k https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/robots.txt``{{execute}}