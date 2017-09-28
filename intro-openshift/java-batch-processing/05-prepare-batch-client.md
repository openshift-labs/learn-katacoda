This step prepares the client side of the batch application, so it knows
how to communicate with the server-side components. We will use ``curl`` to invoke
REST API to perform various batch processing operations.

First, we need to get the application URL and save it to an environment variable
for easy access. Run the following command in the terminal:

``oc status``{{execute}}

```text
In project JBeret Lab (jberet-lab) on server https://172.17.0.41:8443

http://intro-jberet-jberet-lab.2886795305-80-ollie02.environments.katacoda.com to pod port 8080-tcp (svc/intro-jberet)
  dc/intro-jberet deploys istag/intro-jberet:latest <-
    bc/intro-jberet source builds https://github.com/jberet/intro-jberet.git#master on openshift/wildfly:10.1
    deployment #1 deployed about a minute ago - 1 pod

View details with 'oc describe <resource>/<name>' or list everything with 'oc get all'.
```
Create an environment variable by concatenating the application URL (NOT the IP address), 
and ``/intro-jberet/api``{{copy}}. For example (your URL is different):
 
``export APP=http://intro-jberet-jberet-lab.2886795305-80-ollie02.environments.katacoda.com/intro-jberet/api``

Check the value of this environment variable:

``echo $APP``{{execute}}

Run the following query operation (listing all jobs) to verify:

``curl $APP/jobs/``{{execute}}

This returns an empty array of jobs, since no job has been executed yet.




