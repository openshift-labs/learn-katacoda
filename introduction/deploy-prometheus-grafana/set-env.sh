#Helps to address error: x509: certificate signed by unknown authority
# launch.sh
curl -LO https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > /dev/null 2>&1
oc login -u developer -p developer --certificate-authority=lets-encrypt-x3-cross-signed.pem --insecure-skip-tls-verify=true > /dev/null 2>&1

# deploy the demo metrics app
# mkdir -p /tmp/prometheus
oc new-project metrics-demo
oc new-app quay.io/4n4nd/metrics-demo-app:workshop
oc expose svc/metrics-demo-app
# cd /tmp/prometheus
# oc create -f ~/volumes.json --as system:admin > /dev/null 2>&1
#
oc new-project pad-monitoring
oc process -f ~/deploy-prometheus.yaml | oc apply -n pad-monitoring -f -
oc import-image grafana/grafana:6.6.1 --confirm

clear
echo -e "Welcome to your interactive environment. OpenShift is configured and ready to use."
echo -e "The demo metrics application is deployed at: \n http://$(oc get route metrics-demo-app -o jsonpath='{.spec.host}' -n metrics-demo)"
