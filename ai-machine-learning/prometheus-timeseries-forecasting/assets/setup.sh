set +x
curl -LO https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > /dev/null 2>&1
oc login -u developer -p developer --certificate-authority=lets-encrypt-x3-cross-signed.pem --insecure-skip-tls-verify=true > /dev/null 2>&1

oc new-project myproject

curl https://raw.githubusercontent.com/openshift-katacoda/ai-machine-learning-jupyter-notebooks/2.4.0/templates/notebook-deployer.json | sed -e 's/"Redirect"/"Allow"/' | oc apply -f - -n myproject

# set up Notebooks
oc login -u admin -p admin --certificate-authority=lets-encrypt-x3-cross-signed.pem --insecure-skip-tls-verify=true > /dev/null 2>&1
oc adm policy add-scc-to-user anyuid -z default -n myproject
oc process -f ./notebook-imagestream.yaml | oc apply -f - -n myproject
oc process notebook-deployer -p APPLICATION_NAME=pad-workshop -p NOTEBOOK_IMAGE=prometheus-anomaly-detection-workshop:prometheus-timeseries-forecasting-katacoda -p NOTEBOOK_PASSWORD=secret -p NOTEBOOK_MEMORY=2Gi | oc apply -f - -n myproject
# Deploy Notebooks
oc login -u developer -p developer --certificate-authority=lets-encrypt-x3-cross-signed.pem --insecure-skip-tls-verify=true > /dev/null 2>&1
clear

echo -e "The environment should be ready in a few minutes."
echo -e "Once ready, the url to access the Jupyter Notebooks is: \n https://$(oc get route pad-workshop -o jsonpath='{.spec.host}' -n myproject) \n\n"
