We will now deploy our Loan Demo rules on an OpenShift JBoss BRMS Decision Server.

---
**NOTE**

This Katacoda OpenShift environment has been provisioned with the required ImageStreams and Templates to run the JBoss BRMS Decision Server. In order to run this demo on a vanilla OpenShift environment one needs to correctly prepare the environment. To do this:

First install the JBoss ImageStreams:

`oc create -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/jboss-image-streams.json -n openshift`{{copy}}

Next, add the required template:

`oc create -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/decisionserver/decisionserver64-basic-s2i.json -n openshift`{{copy}}

---

Create the new project with the following command:

`oc new-project loan-demo --display-name="Loan Demo" --description="Red Hat JBoss BRMS Decision Server Loan Demo"`{{copy}}

The platform will automatically switch to our new project.

We will use the *decision-server64-basic-s2i* template to define and configure our new application. We point the template to our repositoy on GitHub containing the source code of our Loan Demo rules project"

`oc new-app --template=decisionserver64-basic-s2i -p APPLICATION_NAME="loan-demo" -p KIE_SERVER_USER="brmsAdmin" -p KIE_SERVER_PASSWORD="jbossbrms@01" -p SOURCE_REPOSITORY_URL="https://github.com/DuncanDoyle/loan.git" -p SOURCE_REPOSITORY_REF=master -p KIE_CONTAINER_DEPLOYMENT="container-loan10=com.redhat.demos:loandemo:1.0" -p CONTEXT_DIR="loandemo"`{{copy}}

This “oc” command requires some explanation:

1. new-app: indicates that we want to create a new application in the current project.
2. --template=decisionserver64-basic-s2i: use the JBoss BRMS Decision Server 6.3 Source-2-Image template
3. APPLICATION_NAME: the name of the application
4. KIE_SERVER_USER: the username to login to the Decision Server
5. KIE_SERVER_PASSWORD: the password to login to the Decision Server
6. SOURCE_REPOSITORY_URL: the location of the Git repository that contains our BRMS project (the project containing our rules).
7. SOURCE_REPOSITORY_REF: the Git repository’s branch to use.
8. KIE_CONTAINER_DEPLOYMENT: the name of the KIE Container (in this case `container-loan10`) and the Maven GAV (GroupId, ArtifactId and Version) of the KJAR to be deployed in this KIE Container (in this case `com.redhat.demos:loandemo:1.0`).
9. CONTEXT_DIR: the name of the directory in which the S2I image should execute the Maven commands to build the project (KJAR).
More information about these properties can be found here.

The build will start automatically. Build status can be retrieved with the command `oc get builds`{{copy}}. This will list all the builds for this project on the current system. If we want to have more details about, for example, build *loan-demo-1*, we can use the following command `oc describe build/loan-demo-1`. To view the log of a certain build, for example build *loan-demo-1*, we can use the oc commmand `oc logs build/loan-demo-1`{{copy}}

If the build does not start automatically, we can manually start a build with the following command:

`oc start-build loan-demo`{{copy}}

(Note that this command can produce an error stating that the *latest image tag* can not be found. However, after some time the build will start.)

When all commands have executed successfully, a *Loan Demo Decision Server* container image build should now be running. This can be verified via the “oc” command `oc describe build`{{copy}} which will provide information of the builds defined on the system.

The initial build can take some time as Maven dependencies need to be downloaded.

When the build has successfully finished, an OpenShift pod running our rules in a Decision Server should now be available. To validate that a Decision Server instance is running, we open the [OpenShift Administration Console](https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com) and navigate to our *Loan Demo* project. The *Overview* page shows our Pod with a blue ring with the number 1, indicating that 1 pod is up and running and ready to go (note that the OpenShift platform allows us to easily scale up and down the number of running *loan-demo* instances/pods by clicking on the “up” and “down” arrows).
