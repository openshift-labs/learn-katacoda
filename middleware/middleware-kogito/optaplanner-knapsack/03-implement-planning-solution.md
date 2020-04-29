In the previous step you've implement the domain model of the application. Now it's time to implement the _PlanningSolution_.

## PlanningSolution

The `PlanningSolution` of your OptaPlanner application represents both the problem (i.e. the uninitialized solution,), the working solution, and the best solution, which is returned by OptaPlanner when solving is ended.

## KnapsackSolution.

We will now implement the skeleton of our `KnapsackSolution` class. To do this, we first create a new `KnapsackSolution.java` file by clicking: `knapsack-optaplanner-quarkus/src/main/java/org/acme/PersonUnit.java`{{open}}

Click on the _Copy to Editor_ link to copy the source code into the new `PersonUnit.java`file.

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/KnapsackSolution.java" data-target="replace">
package com.redhat.knapsackoptaplanner.domain;

import java.util.List;

import org.optaplanner.core.api.domain.solution.PlanningEntityCollectionProperty;
import org.optaplanner.core.api.domain.solution.PlanningScore;
import org.optaplanner.core.api.domain.solution.PlanningSolution;
import org.optaplanner.core.api.domain.solution.drools.ProblemFactProperty;
import org.optaplanner.core.api.domain.valuerange.CountableValueRange;
import org.optaplanner.core.api.domain.valuerange.ValueRangeFactory;
import org.optaplanner.core.api.domain.valuerange.ValueRangeProvider;
import org.optaplanner.core.api.score.buildin.hardsoft.HardSoftScore;

//Add PlanningSolution annotation here
public class KnapsackSolution {

    //Add Ingots here

    //Add Knapsack here

    //Add selected valuerangeprovider here

    //Add PlanningScore here

    public KnapsackSolution() {
    }

    //Add getters and setters here
}
</pre>


<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/KnapsackSolution.java" data-target="insert" data-marker="//Add Ingots here">
  @PlanningEntityCollectionProperty
  private List&lt;Ingot&gt; ingots;
</pre>

We also need to create the _getters and setters_:

<pre class="file" data-filename="/knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/KnapsackSolution.java" data-target="insert" data-marker="//Add getters and setters here">
  public List&lt;Ingot&gt; getIngots() {
      return ingots;
  }

  public void setIngots(List&lt;Ingot&gt; ingots) {
      this.ingots = ingots;
  }

  public Knapsack getKnapsack() {
      return knapsack;
  }

  public void setKnapsack(Knapsack knapsack) {
      this.knapsack = knapsack;
  }

  public HardSoftScore getScore() {
      return score;
  }

  public void setScore(HardSoftScore score) {
      this.score = score;
  }
</pre>

That's it. We're now ready to define our constraints.

## Congratulations!

In this step you've implemented the `PlanningSolution` of your application. Well done! In the next step we will implement the constraints of our problem using `ConstraintStreams`.
