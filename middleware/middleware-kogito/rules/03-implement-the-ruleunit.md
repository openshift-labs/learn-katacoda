In the previous step you've implement the domain model of the application. Now it's time to implement the _RuleUnit_.

## Rule Unit

_Rule Units_ are groups of data sources, global variables, and DRL rules that function together for a specific purpose. You can use rule units to partition a rule set into smaller units, bind different data sources to those units, and then execute the individual unit.

## PersonUnit.

We will first implement the skeleton of our `PersonUnit` class. To do this, we first create a new `PersonUnit.java` file by clicking: `adult-service/src/main/java/org/acme/PersonUnit.java`{{open}}

Click on the _Copy to Editor_ link to copy the source code into the new `PersonUnit.java`file.

<pre class="file" data-filename="./adult-service/src/main/java/org/acme/PersonUnit.java" data-target="replace">
package org.acme;

import org.acme.domain.Person;
import org.kie.kogito.rules.DataSource;
import org.kie.kogito.rules.DataStore;
import org.kie.kogito.rules.RuleUnitData;

public class PersonUnit implements RuleUnitData {

//Add Person DataStore here

//Add adultAge variable here

    public PersonUnit() {

    }

//Add DataStore Getters and Setters here

//Add adultAge Getters and Setters here

}
</pre>

We now need to create out `DataSource` for our `Person` facts. A `DataSource` provides us with a typed API to add _facts_ to our unit. Kogito provides a number of different `DataSources` types, for example a `DataStore`, which allows users to insert, update and remove facts, and a `DataStream` that only allows to append facts to a stream.

In this example we will be using the `DataStore` implementation for our `Person` facts. We therefore add a private `DataStore` variable to our rule unit. We use the `DataSource` factory class to create a new `DataStore` instance and assign it to the variable:

<pre class="file" data-filename="./adult-service/src/main/java/org/acme/PersonUnit.java" data-target="insert" data-marker="//Add Person DataStore here">
  private DataStore&lt;Person&gt; persons = DataSource.createStore();
</pre>

We also create the _getters and setters_ for our store:

<pre class="file" data-filename="./adult-service/src/main/java/org/acme/PersonUnit.java" data-target="insert" data-marker="//Add DataStore Getters and Setters here">
  public DataStore&lt;Person&gt; getPersons() {
      return persons;
  }

  public void setPersons(DataStore&lt;Person&gt; persons) {
      this.persons = persons;
  }
</pre>

That's it for now. We will implement some additional functionality to this unit later in this scenario.

## Congratulations!

In this step you've implemented your first _Rule Unit_. Well done! In the next step we will implement the rules and queries of our rule unit.
