In this scenario, you will learn how to implement an [OptaPlanner](https://www.optaplanner.org) application on [Quarkus](https://www.quarkus.io).

![Logo](/openshift/assets/middleware/middleware-kogito/logo.png)
![Logo](/openshift/assets/middleware/middleware-kogito/optaPlannerLogo.png)

### Knapsack Problem

The knapsack problem is a problem in combinatoral optimization: given a knapsack that can contain a maximum weight and a set of items with a certain
weight and value, determine the combination of items to include in the knapsack that maximizes the value of the contents without exceeding the knapsack weight limit.

![Knapsack Problem](https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Knapsack.svg/500px-Knapsack.svg.png)

(image source: https://commons.wikimedia.org/wiki/File:Knapsack.svg , license: https://creativecommons.org/licenses/by-sa/2.5/deed.en)

In this example, we have ingots of different weights and values that we want to put in our knapsack. OptaPlanner will select the combination of ingots that won't exceed the knapsack's maximum weight but will provide the highest value possible.

OptaPlanner is an A.I. constraint satisfaction solver that provides a highly scalable platform to find optimal solutions to NP-complete and NP-hard problems. OptaPlanner enables us to write these solutions in plain Java, which makes this technology available to a large group of software developers. Furthermore, the OptaPlanner Quarkus extension lets us write our OptaPlanner application as a cloud-native micro-service.

### Other possibilities

Learn more at [optaplanner.org](https://optaplanner.org), [kogito.kie.org](https://kogito.kie.org), and [quarkus.io](https://quarkus.io), or just drive on and get hands-on!
