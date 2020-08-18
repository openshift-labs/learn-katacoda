<br>
# Installation
This installation method will use the latest version of the operator image that has been built and published to docker hub.

``cd glowing-quantum``{{execute}}

## Custom Resource Definition
Deploy the custom resource definition (CRD)
``oc create -f operators-examples/qiskit-dev-operator/operator/deploy/crds/singhp11.io_qiskitplaygrounds_crd.yaml``{{execute}}
``oc create -f operators-examples/qiskit-dev-operator/operator/deploy/crds/singhp11.io_v1_qiskitplayground_cr.yaml``{{execute}}

## Deploy the RBAC configuration:
``oc apply -f operators-examples/qiskit-dev-operator/operator/deploy/role.yaml``{{execute}}
``oc apply -f operators-examples/qiskit-dev-operator/operator/deploy/service_account.yaml``{{execute}}
``oc apply -f operators-examples/qiskit-dev-operator/operator/deploy/role_binding.yaml``{{execute}}

## Setting up authorization with IBMQ Account token
 
Insert the value of the account token into the secret.cfg file.

``vi operators-examples/qiskit-dev-operator/operator/deploy/secret.cfg``{{execute}}

NOTE: Use the token provided to you at https://quantum-computing.ibm.com/account.

```
[AUTH TOKENS]
token = your_IBMQ_account_token
```

## Create the secret
``oc create secret generic qiskit-secret --from-file=qiskit-secret.cfg=operators-examples/qiskit-dev-operator/operator/deploy/secret.cfg``{{execute}}


## Deploy the operator itself:

``oc apply -f operators-examples/qiskit-dev-operator/operator/deploy/operator.yaml``{{execute}}

## Wait for the operator pod deployment to complete:

``oc get pods -w``{{execute}}

NOTE: When the pods are running enter Ctrl+c


## Deploy an instance of the custom resource:
``oc create -f operators-examples/qiskit-dev-operator/operator/deploy/crds/singhp11.io_v1_qiskitplayground_cr.yaml``{{execute}}

## The notebook is found on the exposed route
``oc get routes``{{execute}}
