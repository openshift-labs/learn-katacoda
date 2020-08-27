In this step, we will create the OptaPlanner Quarkus application skeleton.

# The Project

We start with a basic Maven-based Quarkus application which has been generated from the Quarkus Maven Plugin.

# The Application You Will Build

In this scenario, we will build an OptaPlanner application on Quarkus that will solve the knapsack problem. The knapsack problem is a problem in which we need to put ingots with a certain weight and a certain value into a knapsack in such a way that we maximize the value without exceeding the maximum knapsack weight. The knapsack problem is an _NP-complete_ problem, which means it's not solvable in polynomial time. In other words, when the size of the problem grows, the time needed to solve the problem grows exponentially. For even relatively small problems, this means that finding the best solution can take billions of years.

OptaPlanner is an A.I. constraint satisfaction solver that enables us to find the optimal solution to these kinds of problems in the limited time at our disposal. In this scenario, we will build an OptaPlanner application that runs on Quarkus to solve this problem.


# Creating a basic project

The easiest way to create a new Quarkus project is to click the following Maven command:

`mvn io.quarkus:quarkus-maven-plugin:1.7.0.Final:create \
    -DprojectGroupId=com.redhat \
    -DprojectArtifactId=knapsack-optaplanner-quarkus \
    -DclassName="com.redhat.knapsackoptaplanner.solver.KnapsackResource" \
    -Dpath="/knapsack" \
    -Dextensions="org.optaplanner:optaplanner-quarkus,org.optaplanner:optaplanner-quarkus-jackson,quarkus-resteasy-jackson,quarkus-smallrye-openapi"`{{execute}}


This command uses the Quarkus Maven plugin and generates a basic Quarkus application that includes the OptaPlanner extension in the `knapsack-optaplanner-quarkus` subdirectory.

Click the following command to remove the automatically generated unit-test classes:
`rm -rf /root/projects/kogito/knapsack-optaplanner-quarkus/src/test/java/com`{{execute}}`

# Running the Application

Click the following command to change directory to the `knapsack-optaplanner-quarkus` directory:

`cd /root/projects/kogito/knapsack-optaplanner-quarkus`{{execute}}

Click the next command to run the OptaPlanner application in Quarkus development mode. This enables us to keep the application running while we implement our application logic. OptaPlanner and Quarkus will hot reload the application (update changes while the application is running) when it is accessed and changes have been detected:

`mvn clean compile quarkus:dev`{{execute}}

The application starts in development mode, but returns an error that it can't find any classes annotated with `@PlanningSolution`. This is expected! We will implement these classes later.

# Congratulations!

We've seen how to create the skeleton of a basic OptaPlanner on Quarkus application, and start the application in Quarkus development mode.

In the next step we'll add the domain model of our application.
