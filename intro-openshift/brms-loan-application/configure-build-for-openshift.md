The Red Hat JBoss BRMS Decision Server in OpenShift Container Platform uses the so-called S2I, or Source-to-Image, concept to build its OpenShift (Docker) container images. In essence, you provide S2I the source code of your rules project, and the build-system will use Maven to build the KJAR (Knowledge JAR) containing the data model and rules, deploy this KJAR onto the Decision Server and create the container image.

Because S2I uses Maven, we first need to make sure that our project is buildable by Maven. To verify this, we clone the project onto our local filesystem. Business Central uses a Git repository for storage under the covers, so we can simply use our favorite Git tool to clone the BRMS repository:

`git clone ssh://brmsAdmin@localhost:8001/loan`{{copy}}

When asked for the password, use `jbossbrms1!`{{copy}}

---
**NOTE**

The Git implementation of Business Central uses an older public key algorithm (DAS). Our Katacoda instance supports this algorithm by default, but on other machines, it might be required to add the following settings to your SSH configuration file (on Linux and macOS this file is located at “~/.ssh/config”).

```
 Host localhost
 HostKeyAlgorithms +ssh-dss
 ```

---

After the project has been successfully cloned, go to the “loan/loan” directory and run “mvn clean install” to start the Maven build. If all his correct, this will produce a build failure:

```
 [INFO] ------------------------------------------------------------------------
 [INFO] BUILD FAILURE
 [INFO] ------------------------------------------------------------------------
 [INFO] Total time: 7.982 s
 [INFO] Finished at: 2017-06-07T23:26:18+02:00
 [INFO] Final Memory: 34M/396M
 [INFO] ------------------------------------------------------------------------
 [ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:2.5.1-jboss-2:compile (default-compile) on project loandemo: Compilation failure: Compilation failure:
 [ERROR] /Users/ddoyle/Development/github/jbossdemocentral/bla/loan/loandemo/src/main/java/com/redhat/demos/loandemo/Applicant.java:[12,32] package org.kie.api.definition.type does not exist
 [ERROR] /Users/ddoyle/Development/github/jbossdemocentral/bla/loan/loandemo/src/main/java/com/redhat/demos/loandemo/Applicant.java:[14,32] package org.kie.api.definition.type does not exist
 [ERROR] /Users/ddoyle/Development/github/jbossdemocentral/bla/loan/loandemo/src/main/java/com/redhat/demos/loandemo/Loan.java:[12,32] package org.kie.api.definition.type does not exist
 [ERROR] /Users/ddoyle/Development/github/jbossdemocentral/bla/loan/loandemo/src/main/java/com/redhat/demos/loandemo/Loan.java:[14,32] package org.kie.api.definition.type does not exist
 [ERROR] /Users/ddoyle/Development/github/jbossdemocentral/bla/loan/loandemo/src/main/java/com/redhat/demos/loandemo/Loan.java:[16,32] package org.kie.api.definition.type does not exist
 [ERROR] /Users/ddoyle/Development/github/jbossdemocentral/bla/loan/loandemo/src/main/java/com/redhat/demos/loandemo/Loan.java:[18,32] package org.kie.api.definition.type does not exist
```


This is because our domain model contains Java annotations from the “kie-api” library, however, that dependency is not defined in the “pom.xml” project descriptor of our project. This dependency is not required for builds done in Business Central, as Business Central provides this JAR on the build path implicitly. However, we need to explicitly define this dependency in our “pom.xml” file for our local and Decision Server S2I Maven builds to succeed.

Add the following dependency to the “pom.xml” file of the project:

```
<dependencies>
   <dependency>
     <groupId>org.kie</groupId>
     <artifactId>kie-api</artifactId>
     <version>6.5.0.Final-redhat-2</version>
     <scope>provided</scope>
   </dependency>
</dependencies>
```

Note the “provided” scope, as we only require this dependency at compile time. At runtime, this dependency is provided by the Decision Server platform.

Run the build again: “mvn clean install”. The build should now succeed. We can commit these changes and push them back to our Git repository in Business Central with the following commands:

`git add pom.xml`{{copy}}

`git commit -m "Added kie-api dependency to POM."`{{copy}}

`git push`{{copy}}

Again, when asked for a password, use `jbossbrms1!`{{copy}}
