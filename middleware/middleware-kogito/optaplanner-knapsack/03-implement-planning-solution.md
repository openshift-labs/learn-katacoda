In the previous step you've implement the domain model of the application. Now it's time to implement the _PlanningSolution_.

## PlanningSolution

The `PlanningSolution` of your OptaPlanner application represents both the problem (i.e. the uninitialized solution,), the working solution, and the best solution, which is returned by OptaPlanner when solving is ended.

The `PlanningSolution` therefore contains:

* The collection of `PlanningEntities` that need to be planned. In this case this is a list of `Ingots`.
* Zero or more collections/ranges of `PlanningVariables`. In this simple example we only have a range of `Booleans` (i.e. `true` and `false`) that indicate whether an `Ingot` has been selected or not.
* Possible `ProblemFactProperties`. These are properties that are neither a `PlanningEntity` nor a `PlanningVariable`, but are required by the constraints during solving. In this example the `Knapsack` is such a propert, as we require the maximum weight of the knapsack in our constraint evaluation.
* The `Score` of the solution. This contains the score calculated by the OptaPlanner `ScoreCalculator` based on the hard and soft constraints.

## KnapsackSolution.

We will now implement the skeleton of our `KnapsackSolution` class. To do this, we first create a new `KnapsackSolution.java` file by clicking: `knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/KnapsackSolution.java`{{open}}

Click on the _Copy to Editor_ link to copy the source code into the new `KnapsackSolution.java`file.

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

To mark this class as our `PlanningSolution` class, we need to add the `@PlanningSolution` annotation:

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/KnapsackSolution.java" data-target="insert" data-marker="//Add PlanningSolution annotation here">
@PlanningSolution
</pre>


### Planning Entities

We can now add the collection of `PlanningEntities` to our class. As stated earlier, in this implementation this is a `List` of `Ingot`. We also need to tell OptaPlanner that this is the collection of `PlanningEntities`, and hence need to annotate this field with the `@PlanningEntityCollectionProperty` annotation:

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/KnapsackSolution.java" data-target="insert" data-marker="//Add Ingots here">
  @PlanningEntityCollectionProperty
  private List&lt;Ingot&gt; ingots;
</pre>

### Valuerange Provider

Next, we can add the _valuerange provider_ to our solution class. This is provider of the valuerange of our `selected` planning variable that we've defined in our `Ingot` planning entity class. Since this planning variable is a `Boolean`, we need to create a `Boolean` value range:

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/KnapsackSolution.java" data-target="insert" data-marker="//Add selected valuerangeprovider here">
  @ValueRangeProvider(id = "selected")
  public CountableValueRange<Boolean> getSelected() {
    return ValueRangeFactory.createBooleanValueRange();
  }
</pre>

### Problem Facts

Our constraints, that we will implement in the following step of our scenario, will need to know the maximum weight of our knapsack to be able to determine whether it can still carry the total weight of the selected ingots. As such, our constraints need to have access to the `Knapsack` instance. We will therefore create a knapsack attribute in our planning solution and annotate it with the `@ProblemFactProperty` annotation (note that there is also an `@ProblemFactCollectionProperty` annotation for collections):

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/KnapsackSolution.java" data-target="insert" data-marker="//Add Knapsack here">
  @ProblemFactProperty
  private Knapsack knapsack;
</pre>

### Planning Score

The next thing we need to add is the `PlanningScore`. In this knapsack problem we have 2 score types: a _hard score_ and a _soft score_. In OptaPlanner, a broken hard score defines an infeasible solution. In our knapsack application this is for example the case when the total weight of the selected ingots is higher than the maximum weight of the knapsack. The soft score is the score that we want to optimize. In this example, this is the total value of the selected ingots, as we want to have a solution with the highest possible values.

We add a `HardSoftScore` attribute to the planning solution class and add an `@PlanningScore` annotation to this attribute:

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/KnapsackSolution.java" data-target="insert" data-marker="//Add PlanningScore here">
  @PlanningScore
  private HardSoftScore score;
</pre>

### Getters and Setters

Finally, we also need to create the _getters and setters_ for our attributes:

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
