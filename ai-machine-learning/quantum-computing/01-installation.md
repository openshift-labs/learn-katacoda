<br>
# Installation
This installation method will use the latest version of the operator image that has been built and published to docker hub.

``cd glowing-quantum``{{execute}}

## Custom Resource Definition
Deploy the custom resource definition (CRD)
``oc create -f operators-examples/qiskit-dev-operator/operator/deploy/crds/dobtech.io_qiskitplaygrounds_crd.yaml``{{execute}}

## Deploy the RBAC configuration:
``oc apply -f operators-examples/qiskit-dev-operator/operator/deploy/role.yaml``{{execute}}
``oc apply -f operators-examples/qiskit-dev-operator/operator/deploy/service_account.yaml``{{execute}}
``oc apply -f operators-examples/qiskit-dev-operator/operator/deploy/role_binding.yaml``{{execute}}

## Setting up authorization with IBMQ Account token
 
 - Edit the configuration file:
``vi operators-examples/qiskit-dev-operator/operator/deploy/secret.cfg``{{execute}}
[AUTH TOKENS]
token = your_IBMQ_account_token
``
   - Convert the configuration to base64:
``
cat secret.cfg | base64
```
  - Place the output in deploy/secret.yaml as:
```
apiVersion: v1
kind: Secret
metadata:
	name: qiskit-secret
type: Opaque
data:
	qiskit-secret.cfg: <base64 encoded secret.cfg>
``
## Deploy the secret
``oc apply -f operators-examples/qiskit-dev-operator/operator/deploy/secret.yaml``{{execute}}


## Deploy the operator itself:

``oc apply -f operators-examples/qiskit-dev-operator/operator/deploy/operator.yaml``{{execute}}

## Wait for the operator pod deployment to complete:

``oc get pods -w``{{execute}}

## Deploy an instance of the custom resource:
``oc apply -f operators-examples/qiskit-dev-operator/operator/deploy/crds/dobtech.io_v1_qiskitplayground_cr.yaml``{{execute}}

## The notebook is found on the exposed route
``oc get routes``{{execute}}
