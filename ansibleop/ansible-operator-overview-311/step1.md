***

_This step doesn't require changes to the interactive environment, but feel free to explore._

***

## Why an Operator?

Operators make it easy to manage complex stateful applications on top of Kubernetes. However writing an operator today can be difficult because of challenges such as using low level APIs, writing boilerplate, and a lack of modularity which leads to duplication.

The Operator SDK is a framework that uses the controller-runtime library to make writing operators easier by providing:

* High level APIs and abstractions to write the operational logic more intuitively
* Tools for scaffolding and code generation to bootstrap a new project fast
* Extensions to cover common operator use cases

## What is an Ansible Operator?

A collection of building blocks from Operator SDK that enables Ansible to handle the reconciliation logic for an Operator.

## Included in Operator Framework

Ansible Operator is one of the available types of Operators that Operator SDK is able to generate. Operator SDK can create an operator using Golang, Helm, or Ansible.

## How do I use it?

Build your Ansible code on top of a provided base image along with some metadata to map Kubernetes events to Ansible Playbooks or Roles.

![Ansible Operator Flow](https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/ansibleop/ansible-operator-overview/assets/images/ansible-op-flow.png)

The following workflow is for a new **Ansible** operator:

1. Create a new Operator project using the Operator SDK Command Line Interface (CLI)
2. Write the reconciling logic for your object using Ansible Playbooks and Roles
3. Use the SDK CLI to build and generate the operator deployment manifests
4. Optionally add additional CRD's using the SDK CLI and repeat steps 2 and 3

Now, let's dig into the specifics and walk through an example.
