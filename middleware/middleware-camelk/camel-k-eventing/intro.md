# Serverless Eventing Camel K

This example demonstrates the idiomatic way of using [Camel K](https://camel.apache.org/camel-k/latest/index.html) in Knative for building event-driven applications. It leverages the Knative eventing broker as the central point that lets various services communicate via event pub/sub. It also shows how Camel K can be used for connecting the Knative event mesh with external systems, with integrations that can play the roles of "event source" or "event sink".

## What is Camel K?

![Logo](https://www.nicolaferraro.me/images/post-logo-apache-camel-d.png)

### Your Integration Swiss-Army-Knife native on Kubernetes with Camel K

Apache Camel K is a lightweight integration framework built from Apache Camel that runs natively on Kubernetes and is specifically designed for serverless and microservice architectures.

Camel K supports multiple languages for writing integrations. Based the Operator Pattern, Camel K performs operations on Kubernetes resources. Bringing integration to the next level. utilizing the benefit of the Apache Camel project, such as the wide variety of components and Enterprise Integration Patterns (EIP).

Camel K integrate seamlessly with Knative making it the best serverless technology for integration.

## Why Serverless?
Deploying applications as Serverless services is becoming a popular architectural style.

You will need a  platform that can run serverless workloads, while also enabling you to have complete control of the configuration, building, and deployment. Ideally, the platform also supports deploying the applications as linux containers.

##  OpenShift Serverless Eventing
Knative Eventing on OpenShift Container Platform enables developers to use an event-driven architecture with serverless applications. An event-driven architecture is based on the concept of decoupled relationships between event producers that create events, and event sinks, or consumers, that receive them.

Knative Eventing uses standard HTTP POST requests to send and receive events between event producers and consumers. These events conform to the CloudEvents specifications, which enables creating, parsing, sending, and receiving events in any programming language.
