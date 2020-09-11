<br>

This installation method will use the latest version of the operator image that has been built and published to quay.

``cd openshift-quantum-operators/operators-examples/openshift-ibm-quantum-operator/operator/``{{execute}}

## Use/Create a project
Create a new project
``oc new-project quantum-katacoda``{{execute}}

## Custom Resource Definition
Deploy the custom resource definition (CRD)
``oc create -f deploy/crds/singhp11.io_ibmqes_crd.yaml``{{execute}}

## Deploy the RBAC configuration:
``oc apply -f deploy/role.yaml``{{execute}}
``oc apply -f deploy/service_account.yaml``{{execute}}
``oc apply -f deploy/role_binding.yaml``{{execute}}

## Setting up authorization with IBMQ Account token
 
Insert the value of the account token into the secret.cfg file.

``vi deploy/secret.cfg``{{execute}}

NOTE: Use the token provided to you at https://quantum-computing.ibm.com/account.

```
[AUTH TOKENS]
token = your_IBMQ_account_token
```

## Create the secret
``oc create secret generic qiskit-secret --from-file=qiskit-secret.cfg=deploy/secret.cfg``{{execute}}


## Deploy the operator itself:

``oc apply -f deploy/operator.yaml``{{execute}}

## Wait for the operator pod deployment to complete:

``oc get pods -w``{{execute}}

NOTE: When the pods are running enter Ctrl+c


## Deploy an instance of the custom resource:
``oc apply -f deploy/crds/singhp11.io_v1_ibmqe_cr.yaml``{{execute}}