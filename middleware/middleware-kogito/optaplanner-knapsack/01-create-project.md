In this step, you will create the Kogito application skeleton.

# The Project

You start with a basic Maven-based Quarkus application which has been generated from the Quarkus Maven Plugin.

# The Application You Will Build

In this scenario you will build an OptaPlanner application on Quarkus that will solve the knapsack problem. The knapsack problem is a problem in which we need to put ingots with a certain weight and a certain value into a knapsack in such a way that we maximize the value. The knapsack problem is a so called _NP Complete_ problem, which means it's not solvable in polynomial time. In other words, when the size of the problem grows, the time needed to solve the problem grows exponentially. For even relatively small problems, this can mean that finding the best solution could take billions of years.

OptaPlanner is an A.I. Constraint Satisfaction Solver that enables us to find the optimal solution to these kind of problems in the limited time at our disposal. In this scenario you will build an OptaPlanner application to solve this problem.


# Create a basic project

The easiest way to create a new Kogito project is to execute the Maven command below by clicking on it:

`mvn io.quarkus:quarkus-maven-plugin:1.4.1.Final:create \
    -DprojectGroupId=com.redhat \
    -DprojectArtifactId=knapsack-optaplanner-quarkus \
    -DclassName="com.redhat.knapsackoptaplanner.solver.KnapsackResource" \
    -Dpath="/knapsack" \
    -Dextensions="quarkus-optaplanner"`{{execute}}


This will use the Quarkus Maven Plugin and generate a basic Quakus application, including the OptaPlanner extension, for you in the `knapsack-optaplanner-quarkus` subdirectory.

# Running the Application

We will now run the OptaPlanner application in development mode. This allows us to keep the application running while implementing our application logic. OptaPlanner and Quarkus will _hot reload_ the application when it is accessed and changes have been detected.

`cd /root/projects/kogito/knapsack-optaplanner-quarkus`{{execute}}

`mvn clean compile quarkus:dev`{{execute}}

When the application has started, you can access the [Swagger UI](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui).

You should see the following page:

![New OptaPlanner Quarkus Swagger UI](/openshift/assets/middleware/middleware-kogito/new-kogito-quarkus-empty-swagger-ui.png)

It's working!

# Congratulations!

You've seen how to create the skeleton of basic OptaPlanner on Quarkus app, and start the application in _Quarkus dev-mode_.

In the next step we'll add the domain model of our application.
