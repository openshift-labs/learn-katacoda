To copy files from the local machine to the container, the ``oc rsync`` command is again used.

The form of the command when copying files from the local machine to the container is:


```
oc rsync <pod-name>:/remote/dir ./local/dir
```

Unlike when copying from the container to the local machine, there is no form for copying a single file. To copy selected files only, you will need to use the ``--exclude`` and ``--include`` options to filter what is and isn't copied from a specified directory.

To illustrate the process for copying a single file, consider the case where you had deployed a web site and had not included a ``robots.txt`` file, but needed to quickly stop a web robot which was crawling your site.

A request to fetch the current ``robots.txt`` file for the web site fails with a HTTP ``404 Not Found`` response.

``curl --head http://blog-myproject.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/robots.txt``{{execute}}

The local machine already contains a ``robots.txt`` file to be uploaded to the container.

``cat robots.txt``{{execute}}

For the web application being used, it hosts static files out of the ``static`` sub directory of the application source code. To upload the ``robots.txt`` file run:

``oc rsync . $POD:/opt/app-root/src/static --exclude=* --include=robots.txt --no-perms``{{execute}}

As already noted it is not possible to copy a single file, so we indicate that the current directory should be copied, but use the ``--exclude=*`` option to first say that all files should be ignored when copy. That pattern is then overridden for just the ``robots.txt`` file by using the ``--include=robots.txt`` file, ensuring the ``robots.txt`` file is copied.

When copying files to the container, it is required that the directory into which files are being copied exists, and that it is writable to the user or group that the container is being run as. Permissions on directories and files should be set as part of the process of building the image.

In the above command, the ``--no-perms`` option is also used because the target directory in the container, although writable by the group the container is run as, is owned by a different user to that the container is run as. This means that although files can be added to the directory, permissions on existing directories cannot be changed. The ``--no-perms`` options tells ``oc rsync`` to not attempt to update permissions as doing so would fail and cause ``oc rsync`` to return errors.

Having uploaded the ``robots.txt`` file, fetching the ``robots.txt`` file now succeeds.

``curl http://blog-myproject.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/robots.txt``{{execute}}

This worked without needing to take any further actions as the Apache HTTPD server being used to host static files, would automatically detect the presence of a new file in the directory.