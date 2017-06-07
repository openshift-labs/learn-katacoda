To copy files from the local machine to the container, the ``oc rsync`` command is again used.

``curl https://blog-myproject.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/robots.txt``{{execute}}

```
oc rsync ./local/dir <pod-name>:/remote/dir --exclude=* --include=filename
```

``oc rsync . $POD:/opt/app-root/src/static --exclude=* --include=robots.txt``{{execute}}

``curl https://blog-myproject.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/robots.txt``{{execute}}

