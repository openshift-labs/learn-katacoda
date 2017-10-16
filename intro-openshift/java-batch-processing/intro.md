In this self-paced tutorial you will learn how to build, deploy, and execute Java batch application
 using JBeret and WildFly for OpenShift. 
 
Batch processing is typically bulk-oriented, non-interactive, background execution.
It usually involves large volume of data or intensive computation. It is used across
many industries to tackle tasks like data ETL (extract, transform and load), recurring
account statement generation, periodic security scanning, financial portfolio analysis, etc.
 
 [The sample batch application](https://github.com/jberet/intro-jberet)
 demonstrates basic batch processing operations, such as
  
 * composing a job with both batchlet step and chunk step
 * chunked reading and writing with transaction checkpointing
 * start/restart/stop/abandon/schedule job executions
 * list job and step execution details and status
 
## Before you get started

If you are not familiar with the OpenShift Container Platform, it's worth taking a few minutes to understand the basics of the platform as well as the environment that you will be using for this self paced tutorial.  Head on over to [Learning OpenShift - Getting Started](https://learn.openshift.com/introduction/getting-started/).

## About project JBeret

[Project JBeret](https://github.com/jberet/jsr352) implements
JSR 352 (Batch Applications for the Java Platform), and additional
advanced batch processing features in both Java SE and Java EE
environment. JBeret is included in WildFly and JBoss EAP to provide
enterprise batch processing capability.


When using the OpenShift Container Platform there are various ways to deploy a batch application:

* Deploy batch application from an existing Docker-formatted image.
* Build application locally and push the build result into OpenShift using a Binary strategy with the Source-to-Image (S2I) builder.
* Build and deploy from source code contained in a Git repository using a S2I builder.

For our introductory lesson we are going to use OpenShifts S2I repository builder to pull in, build and deploy a Java batch application to WildFly runtime. So let's get started!
