Install Kiali with the following commands:

- Define URLS for Jaeger and Grafana

`export JAEGER_URL="https://tracing-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com"; \
export GRAFANA_URL="https://grafana-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com"; \
export VERSION_LABEL="v0.9.0"`{{execute T1}}

- Install Kiali's configmap

`curl https://raw.githubusercontent.com/kiali/kiali/${VERSION_LABEL}/deploy/openshift/kiali-configmap.yaml | \
  VERSION_LABEL=${VERSION_LABEL} \
  JAEGER_URL=${JAEGER_URL}  \
  GRAFANA_URL=${GRAFANA_URL} envsubst | oc create -n istio-system -f -`{{execute T1}}
  
- Install Kiali's secrets

`curl https://raw.githubusercontent.com/kiali/kiali/${VERSION_LABEL}/deploy/openshift/kiali-secrets.yaml | \
  VERSION_LABEL=${VERSION_LABEL} envsubst | oc create -n istio-system -f -`{{execute T1}}
  
- Deploy Kiali to the cluster

`curl https://raw.githubusercontent.com/kiali/kiali/${VERSION_LABEL}/deploy/openshift/kiali.yaml | \
  VERSION_LABEL=${VERSION_LABEL}  \
  IMAGE_NAME=kiali/kiali \
  IMAGE_VERSION=${VERSION_LABEL}  \
  NAMESPACE=istio-system  \
  VERBOSE_MODE=4  \
  IMAGE_PULL_POLICY_TOKEN="imagePullPolicy: Always" envsubst | oc create -n istio-system -f -`{{execute T1}}
  
- Create a new Route for the port 443

`(oc get route kiali -n istio-system -o json|sed 's/80/443/')|oc apply -n istio-system -f -`{{execute T1}}
  
Installing Kiali may take a minute or two. You can use the following commands to see if the service is running: `oc get pods -w -n istio-system`{{execute T1}}

Wait until the status for Kiali is Running and there are 1/1 pods in the Ready column. To exit, press Ctrl+C.

So now we can access Kiali at http://kiali-istio-system.[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com

![](../../assets/servicemesh/kiali/kiali-login.png)

The default credentials are "admin/admin", but it’s recommended to change them before using it in production.
