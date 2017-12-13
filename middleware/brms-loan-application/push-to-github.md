The JBoss BRMS Decision Server S2I build on OpenShift takes the source code of your project, for example from a Git repository, compiles the sources into a KJAR, deploys the KJAR onto the Decision Server and builds the OpenShift image (detailed information about the xPaaS BRMS image for OpenShift can be found in the [manual](https://access.redhat.com/documentation/en-us/red_hat_jboss_middleware_for_openshift/3/html-single/red_hat_jboss_brms_decision_server_for_openshift/)). Therefore, the S2I build needs to have access to our project’s source code.

Because the OpenShift instance in our demo here in Katacoda will not be able to access the JBoss BRMS Business Central Git repository, we will need to make the Git repository available at a place where our OpenShift instance does have access. In this example we will use GitHub (hence a GitHub account is required), but any Git repository (e.g. BitBucket, GitLab, Gogs) will do.

We will first create an empty *loan* repository in GitHub to which we will push the project we've created earlier in Business Central. In my case I've created the repository: https://www.github.com/DuncanDoyle/loan

As we've already cloned the repository from Business Central locally in our previous step, we will use this local clone to push our repository to GitHub. We therefore add our new repository in GitHub as the *upstream* repository to our local clone:

`git remote add upstream git@github.com:DuncanDoyle/loan.git`{{copy}}

We can now push to our upstream repository.

`git push upstream master`{{copy}}

Our BRMS Loan Demo project is now available on, and accessible via, GitHub.
