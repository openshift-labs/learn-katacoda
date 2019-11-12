To copy files from the local machine to the container, the ``oc rsync`` command is again used.

The form of the command when copying files from the local machine to the container is:


```
oc rsync ./local/dir <pod-name>:/remote/dir
```

Unlike when copying from the container to the local machine, there is no form for copying a single file. To copy selected files only, you will need to use the ``--exclude`` and ``--include`` options to filter what is and isn't copied from a specified directory.

To illustrate the process for copying a single file, consider the case where you had deployed a web site and had not included a ``robots.txt`` file, but needed to quickly stop a web robot which was crawling your site.

A request to fetch the current ``robots.txt`` file for the web site fails with a HTTP ``404 Not Found`` response.

``curl --head http://blog-myproject.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/robots.txt``{{execute}}

Create a ``robots.txt`` file to upload.

``cat > robots.txt << !
User-agent: *
Disallow: /
!``{{execute}}

For the web application being used, it hosts static files out of the ``htdocs`` sub directory of the application source code. To upload the ``robots.txt`` file run:

``oc rsync . $POD:/opt/app-root/src/htdocs --exclude=* --include=robots.txt --no-perms``{{execute}}

As already noted it is not possible to copy a single file, so we indicate that the current directory should be copied, but use the ``--exclude=*`` option to first say that all files should be ignored when performing the copy. That pattern is then overridden for just the ``robots.txt`` file by using the ``--include=robots.txt`` file, ensuring the ``robots.txt`` file is copied.

When copying files to the container, it is required that the directory into which files are being copied exists, and that it is writable to the user or group that the container is being run as. Permissions on directories and files should be set as part of the process of building the image.

In the above command, the ``--no-perms`` option is also used because the target directory in the container, although writable by the group the container is run as, is owned by a different user to that which the container is run as. This means that although files can be added to the directory, permissions on existing directories cannot be changed. The ``--no-perms`` options tells ``oc rsync`` to not attempt to update permissions to avoid it failing and returning errors.

Having uploaded the ``robots.txt`` file, fetching the ``robots.txt`` file again now succeeds.

``curl http://blog-myproject.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/robots.txt``{{execute}}

This worked without needing to take any further actions as the Apache HTTPD server being used to host static files, would automatically detect the presence of a new file in the directory.

If instead of copying a single file you wanted to copy a complete directory, leave off the ``--include`` and ``--exclude`` options. To copy the complete contents of the current directory to the ``htdocs`` directory in the container, run:

``oc rsync . $POD:/opt/app-root/src/htdocs --no-perms``{{execute}}

Just be aware that this will be everything, including notionally hidden files or directories starting with ".". You should therefore be careful, and if necessary be more specific by using ``--include`` or ``--exclude`` options to limit the set of files or directories copied.
