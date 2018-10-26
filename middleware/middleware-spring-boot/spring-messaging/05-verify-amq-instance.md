# Verify AMQ is receiving messages

Click the **OpenShift Console** tab, login, and navigate to our project. Then Select the broker-amq pod

![Application Created](/openshift/assets/middleware/rhoar-messaging/broker-amq.png)

Then Select the current deployment 

![Application Created](/openshift/assets/middleware/rhoar-messaging/broker-amq-deploy.png)

Now Navigate to the bottom of the page and select the pod

![Application Created](/openshift/assets/middleware/rhoar-messaging/broker-amq-pod.png)

Finally, on the right side of the screen, under `Template`, Select `Open Java Console`. This will a web page where you can view the status of the currently deployed AMQ instance. 

![Application Created](/openshift/assets/middleware/rhoar-messaging/broker-amq-console.png)

Now we can see what is happening on our queue. You should now see that there is one consumer, our application, and that there are messages being enqueued and dequeued.

![Application Created](/openshift/assets/middleware/rhoar-messaging/broker-amq-messages.png)

