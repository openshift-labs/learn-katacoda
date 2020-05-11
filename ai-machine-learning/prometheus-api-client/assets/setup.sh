set +x
curl -LO https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > /dev/null 2>&1
oc login -u developer -p developer --certificate-authority=lets-encrypt-x3-cross-signed.pem --insecure-skip-tls-verify=true > /dev/null 2>&1

oc new-project myproject

# set up dummy metrics in PVC
oc process -f ./generate-metrics.yaml | oc apply -n myproject -f - --as system:admin
# set up Prometheus
oc process -f ./deploy-prometheus.yaml | oc apply -n myproject -f - --as system:admin

curl https://raw.githubusercontent.com/jupyter-on-openshift/jupyter-notebooks/2.4.0/templates/notebook-deployer.json | sed -e 's/"Redirect"/"Allow"/' | oc apply -f - -n myproject

# set up Notebooks
oc process -f ./notebook-imagestream.yaml | oc apply -f - -n myproject
oc process notebook-deployer -p APPLICATION_NAME=prometheus-anomaly-detection-workshop -p NOTEBOOK_IMAGE=prometheus-anomaly-detection-workshop:prometheus-api-client-katacoda -p NOTEBOOK_PASSWORD=secret | oc apply -f - -n myproject
clear
echo -e "Waiting for metrics data to be generated... (This might take a couple minutes)"
until [ "$(oc get job prometheus-generate-data -o jsonpath='{.status.succeeded}' -n myproject &)" = "1" ];
do
  sleep 10
done
clear
# set up Prometheus
echo -e "Metric data generated, Setting up Prometheus"
oc rollout latest prometheus-demo


oc logs bc/prometheus-anomaly-detection-workshop -f
clear
echo -e "The environment should be ready in a few seconds"
echo -e "The url to access the Jupyter Notebooks is: \n http://$(oc get route prometheus-anomaly-detection-workshop -o jsonpath='{.spec.host}' -n myproject) \n\n"
echo -e "Prometheus Console is available at: \n http://$(oc get route prometheus-demo-route -o jsonpath='{.spec.host}' -n myproject)"
