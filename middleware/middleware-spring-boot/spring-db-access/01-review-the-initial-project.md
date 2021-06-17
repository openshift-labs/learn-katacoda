# Import the code

Let's refresh the code we'll be using. Run the following command to clone the sample project:

`cd /root/projects && rm -rf rhoar-getting-started && git clone https://github.com/openshift-katacoda/rhoar-getting-started && cd rhoar-getting-started/spring/spring-db-access`{{execute}}

# Review the base structure of the application

For your convenience, this scenario has been created with a base project using the Java programming language and the Apache Maven build tool. Initially the project contains a couple web-oriented files which are out of scope for this module. See the Spring Rest Services module for more details. These files are in place to give a graphical view of the Database content. 

As you review the content you will notice that there are a couple **TODO** comments. **Do not remove them!** These comments are used as markers for later exercises in this scenario. 

In the next section we will add the dependencies and write the class files necessary to run the application.

# Inspect Java runtime

An appropriate Java runtime has been installed for you. Ensure you can use it by running this command:

`java --version`{{execute}}

The command should report the version in use, for example (the versions and dates may be slightly different than the below example):

```console
openjdk 11.0.10 2021-01-19
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.10+9)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 11.0.10+9, mixed mode)
```

If the command fails, wait a few moments and try again (it is installed in a background process and make take a few moments depending on system load).