In the previous step we've created a skeleton OptaPlanner application with Quarkus and started the application in Quarkus development mode. In this step we'll create the domain model of our application.

## PlanningEntities and PlanningVariables

Each OptaPlanner application has planning entities (`@PlanningEntity` annotation) and planning variables (`@PlanningVariable` annotation). Planning entities are the entities in our domain that OptaPlanner needs to plan. In the knapsack problem, these are the ingots because these are the entities that are either put into the knapsack or not.

Planning variables are properties of a planning entity that specify a planning value that changes during planning. In the knapsack problem, this is the property that tells OptaPlanner whether or not the ingot is _selected_. That is, whether or not it is put in the knapsack. Note that in this example we have a single knapsack. If we have multiple knapsacks, the actual knapsack is the planning variable, because an ingot can be placed in different knapsacks.

## Ingot

To implement the `Ingot` class, first we need to create a new package in our project:

`mkdir -p /root/projects/kogito/knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain`{{execute T2}}

Click on the following line to open a new `Ingot.java` file in this package: `knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/Ingot.java`{{open}}

Click _Copy to Editor_ to copy the source code into the new `Ingot.java`file.

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/Ingot.java" data-target="replace">
package com.redhat.knapsackoptaplanner.domain;

import org.optaplanner.core.api.domain.entity.PlanningEntity;
import org.optaplanner.core.api.domain.variable.PlanningVariable;

/**
 * Ingot
 */
//Add PlanningEntity annotation
public class Ingot {

    private int weight;

    private int value;

    //Add Planning Variable annotation
    private Boolean selected;

    public Ingot() {
    }

    public int getWeight() {
        return weight;
    }

    public void setWeight(int weight) {
        this.weight = weight;
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }

    public Boolean getSelected() {
        return selected;
    }

    public void setSelected(Boolean selected) {
        this.selected = selected;
    }

}
</pre>

### Planning Entity

We first need to tell OptaPlanner that this class is our `PlanningEntity` class. To do this, click _Copy to Editor_ to set the `@PlanningEntity` annotation on the class.

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/Ingot.java" data-target="insert" data-marker="//Add PlanningEntity annotation">
@PlanningEntity
</pre>

#### Planning Variable

Next, we need to configure our planning variable. In this example, the planning variable (the property that changes during planning) is the `selected` attribute of the planning entity class. Mark this property with the `@PlanningVariable` annotation and specify the _valuerange provider_. This is the entity in our application that provides the range of possible values of our planning variable.

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/Ingot.java" data-target="insert" data-marker="  //Add Planning Variable annotation">
  @PlanningVariable(valueRangeProviderRefs = "selected")
</pre>

In this example, because our planning variable is a `Boolean` value, the _valuerange_ is simply `true` and `false`. We will define this provider in the next step.

## Knapsack

In our application, we need to have an object that defines the maximum weight of our knapsack. So we will implement a simple `Knapsack` class that has a `maxWeight` attribute that can hold this value.

Click the following line to open a new `Knapsack.java` file in this package: `knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/Knapsack.java`{{open}}

Click _Copy to Editor_ to add a class with a single `maxWeight` attribute.

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/com/redhat/knapsackoptaplanner/domain/Knapsack.java" data-target="replace">
package com.redhat.knapsackoptaplanner.domain;

public class Knapsack {

    private int maxWeight;

    public Knapsack() {
    }

    public int getMaxWeight() {
        return maxWeight;
    }

    public void setMaxWeight(int maxWeight) {
        this.maxWeight = maxWeight;
    }

}
</pre>

## Congratulations!

We've implemented the domain model of our OptaPlanner Quarkus application. In the next step, we will implement the _PlanningSolution_ of our application.
