In this scenario, you will learn how to implement (business) rules in [Kogito](https://kogito.kie.org) using _rule units_.

![Logo](/openshift/assets/middleware/middleware-kogito/logo.png)

### Knapsack Problem

The knapsack problem is a problem in combinatoral optimization: given a knapsack with a given weight, and a set of items with a certain
weight and value, determine the combination of items to include in the knapsack in such a way that maximizes the value.

![Knapsack Problem](https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Knapsack.svg/500px-Knapsack.svg.png)

(image source: https://commons.wikimedia.org/wiki/File:Knapsack.svg , license: https://creativecommons.org/licenses/by-sa/2.5/deed.en)

In this example, we will be placing ingots of different weights and values in our knapsack. OptaPlanner will select those ingots that together don't overload the knapsack and of which the sum of their values is as high as possible.

OptaPlanner is an A.I. Constraint Satisfaction Solver that provides a highly scalable platform to find optimal solutions to NP-Complete and NP-Hard problems. OptaPlanner allows you to write these solutions in plain Java, making this technology available to a large group of software developers. Furthermore, the OptaPlanner Quarkus extension allows us to write our OptaPlanner application as a cloud-native micro-service.

### Other possibilities

Learn more at [optaplanner.org](https://optaplanner.org), [kogito.kie.org](https://kogito.kie.org), and [quarkus.io](https://quarkus.io), or just drive on and get hands-on!
