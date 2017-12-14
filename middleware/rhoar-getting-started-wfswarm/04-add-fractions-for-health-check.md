## What is a Fraction?

WildFly Swarm is defined by an unbounded set of capabilities. Each piece of functionality is called a fraction.
Some fractions provide only access to APIs, such as JAX-RS or CDI; other fractions provide higher-level capabilities,
such as integration with RHSSO (Keycloak).

The typical method for consuming WildFly Swarm fractions is through Maven coordinates, which you add to the pom.xml
file in your application. The functionality the fraction provides is then packaged with your application into an
_Uberjar_.  An uberjar is a single Java .jar file that includes everything you need to execute your application.
This includes both the runtime components you have selected, along with the application logic.

** 1. Examine the uberjar**

You can see the uberjar (in the `target/` directory) that you built in previous steps:

```ls -l target/*.jar```{{execute}}
            
You should see the uberjar named `healthcheck-1.0.0-SNAPSHOT-swarm.jar` in the listing. This jar file is executed
using `java -jar` when using `mvn wildfly-swarm:run` or when the application is deployed to OpenShift.

An uberjar is useful for many continuous integration and continuous deployment (CI/CD) pipeline styles,
in which a single executable binary artifact is produced and moved through the testing, validation, and
production environments in your organization.
            
** 2. Add `monitor` fraction**

WildFly Swarm includes the `monitor` fraction which automatically adds health check infrastructure to your
application when it is included as a fraction in the project. Click **Copy To Editor** to insert the new dependencies
into the `pom.xml` file:

<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- Add monitor fraction -->">
        &lt;!-- Add monitor fraction --&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;org.wildfly.swarm&lt;/groupId&gt;
            &lt;artifactId&gt;monitor&lt;/artifactId&gt;
        &lt;/dependency&gt;
</pre>


By adding the `monitor` fraction, Fabric8 will automatically add a _readinessProbe_ and _livenessProbe_ to the OpenShift
_DeploymentConfig_ once deployed to OpenShift. But you still need to implement the logic behind
the health check, which you'll do next.

