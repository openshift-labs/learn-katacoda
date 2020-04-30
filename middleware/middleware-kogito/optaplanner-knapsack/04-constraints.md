In the previous step you've implement the `PlanningSolution` of our application. We can now implement constraint rules.

## Constraints

Constraints define how the score of a solution is calculated. Based on the current assignment of planning variables to planning entities, we can calculate a score for the given solution using constraint. In this example, as stated earlier, uses a _hard_ and _soft_ score. A _hard_ score defines an infeasible solution, where the _soft_ score is the score that we want to optimize. Our constraints will calculate these scores.

In this example we will implement two constraint. The first constraint states that a hard constraint is broken when the total weight of the selected ingots is greater than the max weight of the knapsack. I.e. if we select ingots that have a total weight that is greater than the max weight of our knapsack, the solution is infeasible.

The soft constraint, the score that we want to optimize, is the total value if the ingots. I.e. we want to find the solution that maximizes our total value. For this we will implement a constraint that calculates this as a soft score.

## ConstraintStreams

OptaPlanner provides various options to implement your constraints:

* Easy Java: Java implementation that recalculates the full score for every move. Easy to write but extremely slow. Do not use this in production.
* Incremental Java: Java implementation that does incremental score calculation on every move. Fast, but very hard to write and maintain. Not recommeded.
* Drools: rule based constraints written in DRL. Incremental and fast calculation of constraints. Requires knowledge of Drools.
* Constraint Streams: constraints written in API inspired by Java Streams. Incremental and fast calculation of constraints. Requires knowledge of the Streams API.

In this example we will be using the Constraint Streams API.

We will start by implementing the `ConstraintProvider`. The implementation class will be automatically picked up by the OptaPlanner Quarkus runtime without the need for any configuration.

We will implement the `KnapsackConstraintConfiguration` class. To do this, we first need to create a new package in our project:

`mkdir -p /root/projects/kogito/knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/solver`{{execute T2}}

We can no open a new `KnapsackConstraintConfiguration.java` file in this package by clicking: `knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/solver/KnapsackConstraintConfiguration.java`{{open}}

Click on the _Copy to Editor_ link to copy the source code into the new `KnapsackConstraintConfiguration.java`file.

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/solver/KnapsackConstraintConfiguration.java" data-target="replace">
package com.redhat.knapsackoptaplanner.solver;

import com.redhat.knapsackoptaplanner.domain.Ingot;
import com.redhat.knapsackoptaplanner.domain.Knapsack;

import org.optaplanner.core.api.score.buildin.hardsoft.HardSoftScore;
import org.optaplanner.core.api.score.stream.Constraint;
import org.optaplanner.core.api.score.stream.ConstraintCollectors;
import org.optaplanner.core.api.score.stream.ConstraintFactory;
import org.optaplanner.core.api.score.stream.ConstraintProvider;

public class KnapsackConstraintProvider implements ConstraintProvider {

    @Override
    public Constraint[] defineConstraints(ConstraintFactory constraintFactory) {
        return new Constraint[] {
            maxWeight(constraintFactory),
            maxValue(constraintFactory)
        };
    }

    /*
     * Hard constraint
     */
    //Add hard constraint here


    /*
     * Soft constraint
     */
    //Add soft constraint here


}
</pre>

The hard constraint sums up the weight of all selected ingots and compares this with the maximum weight of the knapsack:

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/solver/KnapsackConstraintConfiguration.java" data-target="insert" data-marker="//Add soft constraint here">
  private Constraint maxWeight(ConstraintFactory constraintFactory) {
    return constraintFactory.from(Ingot.class).filter(i -> i.getSelected())
            .groupBy(ConstraintCollectors.sum(i -> i.getWeight())).join(Knapsack.class)
            .filter((ws, k) -> ws > k.getMaxWeight())
            .penalize("Max Weight", HardSoftScore.ONE_HARD, (ws, k) -> ws - k.getMaxWeight());
  }
</pre>

The soft constraints sums up all the values of the selected ingots:

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/solver/KnapsackConstraintConfiguration.java" data-target="insert" data-marker="//Add soft constraint here">
  private Constraint maxValue(ConstraintFactory constraintFactory) {
    return constraintFactory.from(Ingot.class)
                .filter(Ingot::getSelected)
                .reward("Max Value", HardSoftScore.ONE_SOFT, Ingot::getValue);
  }
</pre>

## Congratulations!

In this step you've implemented your first OptaPlanner constraints using the `ConstraintStreams` API. In the next step we will implement our RESTful resource and test our application.
