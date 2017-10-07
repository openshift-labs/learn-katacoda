In this exercise, you will scale and load test a distributed application.

First, lets set up a variable so that we have the site name saved:

``export SITE="http://$(oc get svc | grep wpfrontend | awk '{print $2}')/wp-admin/install.php"``{{execute}}

Test with AB before we scale the application to get a base line. We will run this command from the privileged rhel-tools container on the master node:

``ab -n100 -c 10 -k -H "Accept-Encoding: gzip, deflate" $SITE``{{execute}}


Go to the web interface. Scale the Wordpress Deployment up to three containers. Click the up arrow:

- Applications -> Deployments -> wordpress -> Up Arrow


Test with AB. The response time should now be lower.

``ab -n100 -c 10 -k -H "Accept-Encoding: gzip, deflate" $SITE``{{execute}}


Scale with command line. Run the follwing command to scale with the command line:

``oc scale --replicas=5 rc/wordpress``{{execute}}


Test with AB. The response time should now be even lower.

``ab -n100 -c 10 -k -H "Accept-Encoding: gzip, deflate" $SITE``{{execute}}


Scale the application back down to one pod:

``oc scale --replicas=1 rc/wordpress``{{execute}}

