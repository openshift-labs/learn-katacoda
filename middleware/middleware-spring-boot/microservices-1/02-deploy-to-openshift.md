# Deploy to OpenShift Application Platform

**1. Create a project**

Let's first create a new project:

``oc new-project dev --display-name="Dev - Spring Boot App"``{{execute}}

**2. Additional Configuration**

Before we deploy the application, we have to make a few changes so our application runs smoothly using External Configurations.

The first step is we're going to assign view access rights to the service account we're logged in as. We have to do this before deploying the application so that it's able to access the OpenShift API and read the contents of the `ConfigMap`. We can do that with the following command:

``oc policy add-role-to-user view -n $(oc project -q) -z default``{{execute}}

We should see `clusterrole.rbac.authorization.k8s.io/view added: "default"` as output. The next step is to create our `ConfigMap` configuration and deploy it to OpenShift using:

``oc create configmap spring-boot-configmap-greeting --from-file=src/main/etc/application.properties``{{execute}}

We will talk about `ConfigMap`s in greater detail in the next section.

>**NOTE:** The only two parameters this command needs are the name of the ConfigMap to create and the file location. This command is creating a `ConfigMap` named `spring-boot-configmap-greeting`, which also happens to be the name of the application we're deploying. We're going to be using that name in future commands. If you decide to manually run the command or give the `ConfigMap` a different name, make sure you modify the other commands and configuration accordingly.

Now we're ready to deploy!

**3. Deploy the application to OpenShift**

Run the following command to deploy the application to OpenShift:

``mvn oc:deploy -Popenshift``{{execute}}

There's a lot that happens here so lets break it down:

For the deployment to OpenShift we are using the [JKube](https://www.eclipse.org/jkube/) tool through the [`openshift-maven-plugin`](https://www.eclipse.org/jkube/docs/openshift-maven-plugin), which is configured in our ``pom.xml``{{open}} (found in the `<profiles/>` section). The deployment may take a few minutes to complete.

You can run the command ``oc rollout status -w dc/spring-boot-configmap-greeting``{{execute}} to watch and wait for the deployment to complete.

Once the application deployment completes, navigate to our route in the OpenShift Web View or click [here](http://spring-boot-configmap-greeting-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/). We should see the following screen, meaning everything was successful:

![Greeting Service](/openshift/assets/middleware/rhoar-microservices/greeting-service-mini.png)

**4. Test functionality**

As the page suggests, we're going to put in a name of a fruit and let our greeting service reply with a given greeting. Since our default value in our `ConfigMap` is `Greetings, you picked %s as your favorite fruit!`, that's what we should see after we fill in the textbox and click the button. 

## Congratulations

We've now deployed our application to OpenShift and we're ready to see how we can modify certain aspects of our application without downtime through the use of External Configuration via our ConfigMap.