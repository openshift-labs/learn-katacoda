The web application you deployed was implemented using the Python programming language and used the OpenShift Python Source-to-Image (S2I) builder.

OpenShift provides S2I builders for a number of different programming languages/frameworks including Java, NodeJS, Perl, PHP, Python and Ruby.

Which S2I builders are available in an OpenShift cluster can be determined by browsing the catalog when adding an application to a project from the web console. You can also run from the terminal the command:

``oc new-app -L``{{execute}}

Any bundled S2I builders are located in the ``openshift`` namespace of the OpenShift cluster. You can display details of a S2I builder, including what language versions it provides, by running the command:

``oc describe is/python -n openshift``{{execute}}

For the Python S2I builder this will display:

```
Name:                   python
Namespace:              openshift
Created:                4 minutes ago
Labels:                 <none>
Annotations:            openshift.io/image.dockerRepositoryCheck=2017-06-01T06:02:11Z
Docker Pull Spec:       172.30.156.223:5000/openshift/python
Unique Images:          4
Tags:                   5

3.5 (latest)
  tagged from centos/python-35-centos7:latest

  Build and run Python 3.5 applications
  Tags: builder, python
  Supports: python:3.5, python
  Example Repo: https://github.com/openshift/django-ex.git

  * centos/python-35-centos7@sha256:a005e515db155c0da07d3e09eed53d6691fcd53bf705a835506a11e48950144b
      3 minutes ago

3.4
  tagged from centos/python-34-centos7:latest

  Build and run Python 3.4 applications
  Tags: builder, python
  Supports: python:3.4, python
  Example Repo: https://github.com/openshift/django-ex.git

  * centos/python-34-centos7@sha256:e8c41783051dbe1e5ed33852ad5140002bb82ffa1f21e1d029c7607c05070f27
      3 minutes ago

3.3
  tagged from openshift/python-33-centos7:latest

  Build and run Python 3.3 applications
  Tags: builder, python
  Supports: python:3.3, python
  Example Repo: https://github.com/openshift/django-ex.git

  * openshift/python-33-centos7@sha256:7bbc639e8cb6404682957a671f16408b0d039998671c96bd2cb34a224a820e5a
      3 minutes ago
```

The form of the command to run to use a S2I builder is:

``oc new-app <image:tag>~<source-code> --name <name>``

If for some reason an ambiguity exists and ``oc new-app`` cannot determine which image to use, or the type of build strategy to use, you can be more explicit by using:

``oc new-app --strategy=source --image-stream=<image:tag> <source-code> --name <name>``