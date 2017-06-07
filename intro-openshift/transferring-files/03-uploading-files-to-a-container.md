``curl -k https://blog-myproject.[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/robots.txt``{{execute}}

``oc rsync robots.txt $POD:/opt/app-root/src/static/``{{execute}}

``curl -k https://blog-myproject.[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/robots.txt``{{execute}}