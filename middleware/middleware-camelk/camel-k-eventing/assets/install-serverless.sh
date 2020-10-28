oc login -u admin -p admin

echo "Setting up Serverless..."

# Login as admin
oc login -u admin -p admin


oc apply -f https://raw.githubusercontent.com/weimeilin79/learn-katacoda/master/middleware/middleware-camelk/camel-k-eventing/assets/serverless/subscription.yaml

sleep 3

oc new-project knative-serving
sleep 3


oc apply -f https://raw.githubusercontent.com/weimeilin79/learn-katacoda/master/middleware/middleware-camelk/camel-k-eventing/assets/serverless/serving.yaml -n knative-serving

sleep 3
