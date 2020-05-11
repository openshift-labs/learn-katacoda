In the previous step we've implemented the domain model of the application. Now it's time to implement the planning solution.

## PlanningSolution

The planning solution of our OptaPlanner application represents both the problem (i.e. the uninitialized solution), the working solution, and the best solution which is the solution returned by OptaPlanner when solving is ended.

The `PlanningSolution` class therefore contains:

* The collection of planning entities that need to be planned. In this case, this is a list of `Ingots`.
* Zero or more collections/ranges of planning variables. In this simple example we only have a range of boolean values (i.e. `true` and `false`) that indicate whether an ingot has been selected or not.
* Possible problem fact properties. These are properties that are neither a planning entity nor a planning variable, but are required by the constraints during solving. In this example the `Knapsack` is such a property because the problem requires the maximum weight of the knapsack in the constraint evaluation.
* The `Score` of the solution. This contains the score calculated by the OptaPlanner `ScoreCalculator` based on the hard and soft constraints.

## KnapsackSolution

We will now implement the skeleton of our `KnapsackSolution` class. To do this, click the following line to create a new `KnapsackSolution.java` file: `knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/KnapsackSolution.java`{{open}}

Click _Copy to Editor_ to copy the source code into the new `KnapsackSolution.java` file.

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

We can now add the collection of planning entities to our class. As stated earlier, in this implementation this is a list of ingots. We also need to tell OptaPlanner that this is the collection of planning entities, and therefore need to annotate this field with the `@PlanningEntityCollectionProperty` annotation.

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/KnapsackSolution.java" data-target="insert" data-marker="//Add Ingots here">
  @PlanningEntityCollectionProperty
  private List&lt;Ingot&gt; ingots;
</pre>

### Valuerange Provider

Next, we can add the _valuerange provider_ to our solution class. This is the provider of the valuerange of our `selected` planning variable that we've defined in our `Ingot` planning entity class. Because this planning variable is a boolean value, we need to create a `Boolean` value range.

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/KnapsackSolution.java" data-target="insert" data-marker="//Add selected valuerangeprovider here">
  @ValueRangeProvider(id = "selected")
  public CountableValueRange<Boolean> getSelected() {
    return ValueRangeFactory.createBooleanValueRange();
  }
</pre>

### Problem Facts

The constraints that we will implement in the following step of our scenario need to know the maximum weight of our knapsack to be able to determine whether the knapsack can carry the total weight of the selected ingots. For this reason, our constraints need to have access to the `Knapsack` instance. We will therefore click _Copy to Editor_ to create a knapsack attribute in our planning solution and annotate it with the `@ProblemFactProperty` annotation (note that there is also an `@ProblemFactCollectionProperty` annotation for collections).

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/KnapsackSolution.java" data-target="insert" data-marker="//Add Knapsack here">
  @ProblemFactProperty
  private Knapsack knapsack;
</pre>

### Planning Score

The next thing we need to add is the `PlanningScore`. In this knapsack problem we have two score types: a _hard score_ and a _soft score_. In OptaPlanner, a broken hard score defines an _infeasible solution_. In our knapsack application, for example, this is the case when the total weight of the selected ingots is higher than the maximum weight of the knapsack. The soft score is the score that we want to optimize. In this example, this is the total value of the selected ingots, because we want to have a solution with the highest possible values.

Click _Copy to Editor_ to add a `HardSoftScore` attribute to the planningsolution class and add an `@PlanningScore` annotation to this attribute.

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/KnapsackSolution.java" data-target="insert" data-marker="//Add PlanningScore here">
  @PlanningScore
  private HardSoftScore score;
</pre>

### Getters and Setters

Finally, we also need to create the _getters and setters_ for our attributes.

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
