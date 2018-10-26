# Login and Deploy to OpenShift Container Platform

Now it's time for the fun! The following steps will walk you through deploying the application to OpenShift and running the tests with Arquillian Cube.


**1. Setup OpenShift**

Login to OpenShift using the `oc` command with the developer credentials:

``oc login [[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com --insecure-skip-tls-verify=true -u developer -p developer``{{execute}}


Then we'll create the project:

``oc new-project fruit --display-name="Dev - Fruity App"``{{execute}}

Now create a database:

``oc new-app -e POSTGRESQL_USER=dev -e POSTGRESQL_PASSWORD=secret -e POSTGRESQL_DATABASE=my_data openshift/postgresql-92-centos7 --name=my-database``{{execute}}


**2. Run the integration tests**

Run the following command to deploy the application to OpenShift and run the integration tests:

``mvn clean package -Popenshift``{{execute}}

>**NOTE:** The building, deploying, and testing of the application may take a few minutes

## Unit and Integration Testing with CI/CD
While we are only demonstrating how to create integration tests for a simple project, including automated testing as part of a CI/CD process
is invaluable. Why? There are a number of reasons, but three major points are:

1. Automated tests help ensure that application components work as expected before being used
2. When changes are made in one application component, the automated tests will validate the change did not break other components
3. Automated tests ensures a level of consistent testing because the tests are run every time code is changed


## Congratulations

You have now learned how to run an integration test using Arquillian Cube on OpenShift! In the next step you will add a test scenario!