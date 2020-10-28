In this exercise, you will scale and load test a distributed application.

First, lets set up a variable so that we have the site name saved:

``export SITE="http://$(oc get svc | grep wpfrontend | awk '{print $3}')/wp-admin/install.php"``{{execute}}

Test with AB before we scale the application to get a base line. Take note of the "Time taken for tests" section:

``ab -n10 -c 3 -k -H "Accept-Encoding: gzip, deflate" $SITE``{{execute}}


Take not of the following sections in the output:

- Time taken for tests
- Requests per second
- Percentage of the requests served within a certain time (ms)


Go to the web interface. Scale the Wordpress Deployment up to three containers. Click the up arrow:

- Applications -> Deployments -> wordpress -> Up Arrow


Test with AB again. How did this affect our bencchmarking and why?

``ab -n10 -c 3 -k -H "Accept-Encoding: gzip, deflate" $SITE``{{execute}}


Now lets scale up more with command line instead of the web interface:

``oc scale --replicas=5 rc/wordpress``{{execute}}


Test with AB. How did this affect our bencchmarking and why?

``ab -n10 -c 3 -k -H "Accept-Encoding: gzip, deflate" $SITE``{{execute}}


Scale the application back down to one pod:

``oc scale --replicas=1 rc/wordpress``{{execute}}

Test with AB. How did this affect our bencchmarking and why?

``ab -n10 -c 3 -k -H "Accept-Encoding: gzip, deflate" $SITE``{{execute}}


Sometimes horizontal scaling can have counter intuitive effects. Sometimes great care must be taken with applications to get the performance characteristics that we need. The world of container orchestration opens up an entirely new kind of performance tuning and you will need new skills to tackle this challenge.
