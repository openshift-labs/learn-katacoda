In the previous step we've implemented the constraints of the application using the `ConstraintStreams` API. We will now create the RESTful resource of our application and take the application for a test-drive.

# KnapsackResource

When we created the initial OptaPlanner Quarkus application using the Quarkus Maven plugin, we defined the resource class of our RESTful endpoint (being `KnapsackResource`).

We will now implement the skeleton of our `KnapsackSolution` class. To do this, we first have to open the `KnapsackResource.java` file by clicking the following path: `knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/solver/KnapsackResource.java`{{open}}

The `KnapsackResource` class is implemented as a Quarkus JAX-RS service. Click _Copy to Editor_ to inject an OptaPlanner `SolverManager` instance to manage the `Solver` instances that will solve our problem.

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/solver/KnapsackResource.java" data-target="replace">
package com.redhat.knapsackoptaplanner.solver;

import java.util.UUID;
import java.util.concurrent.ExecutionException;

import javax.inject.Inject;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.redhat.knapsackoptaplanner.domain.KnapsackSolution;

import org.optaplanner.core.api.solver.SolverJob;
import org.optaplanner.core.api.solver.SolverManager;


@Path("/knapsack")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class KnapsackResource {

    @Inject
    private SolverManager&lt;KnapsackSolution, UUID&gt; solverManager;

    @POST
    @Path("/solve")
    public KnapsackSolution solve(KnapsackSolution problem) {
        UUID problemId = UUID.randomUUID();
        // Submit the problem to start solving
        SolverJob&lt;KnapsackSolution, UUID&gt; solverJob = solverManager.solve(problemId, problem);
        KnapsackSolution solution;
        try {
            // Wait until the solving ends
            solution = solverJob.getFinalBestSolution();
        } catch (InterruptedException | ExecutionException e) {
            throw new IllegalStateException("Solving failed.", e);
        }
        return solution;
    }
}
</pre>

SolverManager accepts (uninitialized) PlanningSolutions the problem), and passes this problem to a managed Solver that runs on a separate thread to solve it. The SolverJob runs until solving ends, after which we can retrieve the final best solution.

# Configuring the Solver

OptaPlanner will keep solving the problem indefinitely if we don't configure a _termination strategy_. A _termnination strategy_ tells OptaPlanner when to stop solving, for example based on the number of seconds spent, or if a score has not improved in a specified amount of time.

In an OptaPlanner Quarkus application, we can set this _termination strategy_ by simply adding a configuration property in the Quarkus `application.properties` configuration file. Let's first open this file by clicking the following path: `knapsack-optaplanner-quarkus/src/main/resources/application.properties`{{open}}

Click _Copy to Editor_ to add our _termination strategy_ configuration property:

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/resources/application.properties" data-target="replace">
# Configuration file
# key = value
quarkus.optaplanner.solver.termination.spent-limit=10s
</pre>

The `quarkus.optaplanner.solver.termination.spent-limit` property is set to 10 seconds, which means that the solver will stop solving after 10 seconds and return the best result found so far.

## Running the Application
Because we still have our application running in Quarkus development mode, we can simply access the Swagger-UI of our application by clicking [here](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui). Hitting this endpoint will force the OptaPlanner Quarkus application to do a hot-reload and recompile and deploy the changes we made in our application "on-the-fly".

You will see our `/knapsack/solve` RESTful API listed. We can now fire a RESTful request with a knapsack problem to this endpoint. We will do this from the terminal using cURL. Note that it will take 10 seconds for the response to return because we've set the OptaPlanner termination strategy to 10 seconds:

`curl --location --request POST 'http://localhost:8080/knapsack/solve' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw '{
	"knapsack": {
		"maxWeight": 10
	},
	"ingots" : [
		{
			"weight": 4,
			"value": 15
		},
		{
			"weight": 4,
			"value": 15
		},
		{
			"weight": 3,
			"value": 12
		},
		{
			"weight": 3,
			"value": 12
		},
		{
			"weight": 3,
			"value": 12
		},
		{
			"weight": 2,
			"value": 7
		},
		{
			"weight": 2,
			"value": 7
		},
		{
			"weight": 2,
			"value": 7
		},
		{
			"weight": 2,
			"value": 7
		},
		{
			"weight": 2,
			"value": 7
		}
	]
}'`{{execute T2}}

The response shows which ingots have been selected. These ingots will have their `selected` attribute set to `true`.

## Congratulations!
You've implemented the RESTful endpoint of the application, hot-reloaded the app using the Quarkus dev-mode and solved a knapsack problem. Well done! In the next step we will deploy this application to OpenShift to run our OptaPlanner solution as a true cloud-native application.
