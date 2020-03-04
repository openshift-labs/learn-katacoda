launch.sh
curl -LO https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > /dev/null 2>&1
oc login -u developer -p developer --certificate-authority=lets-encrypt-x3-cross-signed.pem --insecure-skip-tls-verify=true > /dev/null 2>&1

oc new-project myproject
curl https://raw.githubusercontent.com/jupyter-on-openshift/jupyter-notebooks/2.4.0/image-streams/s2i-minimal-notebook.json | oc apply -f - -n myproject
curl https://raw.githubusercontent.com/jupyter-on-openshift/jupyter-notebooks/2.4.0/templates/notebook-builder.json | sed -e 's/"Redirect"/"Allow"/' | oc apply -f - -n myproject
curl https://raw.githubusercontent.com/jupyter-on-openshift/jupyter-notebooks/2.4.0/templates/notebook-deployer.json | sed -e 's/"Redirect"/"Allow"/' | oc apply -f - -n myproject
curl https://raw.githubusercontent.com/jupyter-on-openshift/jupyter-notebooks/2.4.0/templates/notebook-quickstart.json | sed -e 's/"Redirect"/"Allow"/' | oc apply -f - -n myproject
curl https://raw.githubusercontent.com/jupyter-on-openshift/jupyter-notebooks/2.4.0/templates/notebook-workspace.json | sed -e 's/"Redirect"/"Allow"/' | oc apply -f - -n myproject

# set up Notebooks
oc process notebook-builder -p GIT_REPOSITORY_URL=https://github.com/hemajv/prometheus-anomaly-detection-workshop.git -p CONTEXT_DIR=source/prometheus-api-client | oc apply -f - -n myproject
oc process notebook-deployer -p NOTEBOOK_IMAGE=custom-notebook:latest -p NOTEBOOK_PASSWORD=secret | oc apply -f - -n myproject
clear
until [ "$(oc get job prometheus-generate-data -o jsonpath='{.status.succeeded}' -n myproject)" = "1" ];
do
  echo -e "Waiting for metrics data to be generated..."
  sleep 10
done
# set up Prometheus
echo -e "Metric data generated, Setting up Prometheus"
oc rollout latest prometheus-demo


oc logs bc/custom-notebook -f
clear
echo -e "The environment should be ready in a few seconds"
echo -e "The url to access the Jupyter Notebooks is: \n http://$(oc get route custom-notebook -o jsonpath='{.spec.host}' -n myproject) \n\n"
echo -e "Prometheus Console is available at: \n http://$(oc get route prometheus-demo-route -o jsonpath='{.spec.host}' -n myproject)"
