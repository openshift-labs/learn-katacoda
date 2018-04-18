
`odo catalog list`{{execute}}

```
The following components can be deployed:
- httpd
- nodejs
- perl
- php
- python
- ruby
- wildfly
```

`cd ~/backend`{{execute}}

In case we go from source code

`odo create wildfly backend`{{execute}}

`odo push`{{execute}}

on case we want o show binary deployment (**which is not yet implemented, so not usable ATM**)

`mvn package`{{execute}}

`odo create wildfly backend --binary=target/backend-1.war`{{execute}}

You will see

``
please wait, building application...
``

which means the application is being build & deployed in OpenShift, when 
finished it will show the build log and should end with

``
Push successful
``

`odo list`{{execute}}

will report there is one component

``
You have deployed:
backend using the wildfly component
``
