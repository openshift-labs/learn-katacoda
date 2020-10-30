This section will give a brief overview of the *Ansible Operator* with a step-by-step example of developing an Ansible Operator using [Operator SDK](https://sdk.operatorframework.io).

The reader is expected to have a basic understanding of the *Operator pattern*. 
 - Ansible Operator is an Operator which is _powered by Ansible_. 
 - Custom Resource events trigger Ansible tasks as opposed to the traditional approach of handling these events with Go code.

Ansible Operator development and testing is fully supported as a first-class citizen within the Operator SDK. Operator SDK can be used to create new Operator projects, test existing Operator projects, build Operator images, and generate new Custom Resource Definitions (CRDs) for an Operator.

---

By the end of this section the reader should have a basic understanding of:

* What the Ansible Operator is
* How the Ansible Operator maps Custom Resource events to Ansible code
* How to pass extra variables to Ansible code via the operator
* How to leverage existing roles from Ansible Galaxy
* How to deploy and run the Ansible Operator in a OpenShift cluster
* How to run the Ansible Operator Locally for development
