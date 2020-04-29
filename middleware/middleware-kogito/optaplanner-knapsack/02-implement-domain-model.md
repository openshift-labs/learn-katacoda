In the previous step you've created a skeleton OptaPlanner application with Quarkus and started the application in _Quarkus dev-mode_. In this step we'll create the domain model of our application.

## PlanningEntities and PlanningVariables

In every OptaPlanner application, we have so called `PlanningEntities` and `PlanningVariables`. `PlanningEntities` are the entities in your domain that OptaPlanner needs to plan. In our knapsack problem, these are our `ingots`, as these are the entities that are either put into the knapsack or not.

`PlanningVariables` are properties on a `PlanningEntity` that point to a planning value that changes during planning. In our case, this is the property whether the `ingot` is `selected`, i.e. whether it is put in the knapsack (note that in this example we use a single knapsack. If we would have multiple knapsacks, the actual knapsack would be the planning variable, as an ingot could be placed in different knapsacks).


## Ingot

We will implement the `Ingot` class. To do this, we first need to create a new package in our project:

`mkdir -p /root/projects/kogito/knapsack-optaplanner-quarkus/src/main/java/om/redhat/knapsackoptaplanner/domain`{{execute T2}}

We can no open a new `Ingot.java` file in this package by clicking: `knapsack-optaplanner-quarkus/src/main/java/om/redhat/knapsackoptaplanner/domain/Ingot.java`{{open}}

Click on the _Copy to Editor_ link to copy the source code into the new `Ingot.java`file.

<pre class="file" data-filename="./knapsack-optaplanner-quarkus/src/main/java/om/redhat/knapsackoptaplanner/domain/Ingot.java" data-target="replace">
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


## Congratulations!

You've implemented the domain model of your Kogito business rules project. In the next step, we will implement the _RuleUnit_ of our application.
