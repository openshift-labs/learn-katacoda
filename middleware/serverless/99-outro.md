# FAQ
## How to access the Serverless services ?
When looking up the IP address to use for accessing your app, you need to look up the NodePort for the kourier-external as well as the IP address used for minikube. You can use the following command to look up the value to use for the {IP_ADDRESS} placeholder used in the sample
```
#!/bin/bash
IP_ADDRESS="$(minikube ip):$(oc get svc kourier-external --namespace kourier-system --output 'jsonpath={.spec.ports[?(@.port==80)].nodePort}')"

# calling a knative service named greeter
curl -H "Host:greeter.serverless-tutorial.example.com" $IP_ADDRESS
```

## What is a "revision" in simpler terms?
A Revision is an immutable snapshot of code and configuration. Each change to an application’s Configuration creates a new Revision, which allows an application to be rolled back to any previous “known good configuration”.
