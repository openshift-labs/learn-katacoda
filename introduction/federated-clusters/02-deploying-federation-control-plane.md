The scenario is composed of two OpenShift clusters:

* `cluster1`, acting as Host Cluster (top half of the screen)

* `cluster2`, acting as Member Cluster (bottom half of the screen)

You will have access to two terminals, however most of the work will be done on the `cluster1` terminal.

An `admin` user with `cluster-admin` privileges has been created in each cluster for your convenience.

*NOTE:* The current Federation Control Plane deployment requires cluster-admin privileges. This requirement could be addressed in upcoming releases, so specific roles will be available for the Federation Control Plane.

You should be already logged as admin. In order to verify it:

**Cluster 1**

``oc whoami``{{execute HOST1}}

**Cluster 2**

``oc whoami``{{execute HOST2}}

Next step is cloning the Git repository hosting the code used in this course. From the `cluster1` _Terminal_, run the following command:

``git clone --recurse-submodules https://github.com/openshift/federation-dev.git``{{execute HOST1}}

Once the repository has been cloned, change directory into the new directory:

``cd federation-dev``{{execute HOST1}}

You might want to review some configurations already present on the environment:

* Contexts created: You should see cluster1 and cluster2 contexts already present on the configuration, these contexts will be used during the course.

  **Cluster 1**  

  ``oc config get-contexts``{{execute HOST1}}

  **Cluster 2**

  ``oc config get-contexts``{{execute HOST2}}

* Kubefed2 tool already downloaded: You should see the version output for the Kubefed2 tool.

  **Cluster 1**

  ``kubefed2 version``{{execute HOST1}}

  **Cluster 2**

  ``kubefed2 version``{{execute HOST2}}
