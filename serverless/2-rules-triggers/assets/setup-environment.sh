echo "Waiting for Apache OpenWhisk environment to be ready. It can take from 2 to 3 minutes."
# wait until the pods are Running
sleep 30
while $(oc get pods -n faas controller-0 | grep 0/1 > /dev/null); do sleep 1; done
echo "Apache OpenWhisk is Running..."
# Run other setup commands
oc patch route openwhisk --namespace faas -p '{"spec":{"tls": {"insecureEdgeTerminationPolicy": "Allow"}}}'
AUTH_SECRET=$(oc get secret whisk.auth -o yaml | grep "system:" | awk '{print $2}' | base64 --decode)
wsk property set --auth $AUTH_SECRET --apihost $(oc get route/openwhisk --template="{{.spec.host}}")
sleep 5
wsk -i property get
wsk -i action list
