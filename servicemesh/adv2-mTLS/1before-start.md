You need to remove the customer route you created at the beginning of the tutorial.

To do it just run: `oc delete route customer`{{execute T1}}

Then, you need to enable Istio Ingress to receive all traffic and redirect it to customer service. For this reason, let’s create a Gateway and VirtualService that allows local calls reach the clustered service inside the mesh.

`istioctl create -f ~/projects/istio-tutorial/istiofiles/gateway-customer.yml`{{execute T1}}

Then configure some environment variables that will help you on testing:

`export INGRESS_PORT=$(oc -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}'); \
export GATEWAY_URL=http://customer-tutorial.[[HOST_SUBDOMAIN]]-$INGRESS_PORT-[[KATACODA_HOST]].environments.katacoda.com; `{{execute T1}}

Now you can run curl but against GATEWAY_URL and you’ll see the same messages as before (`customer => preference => recommendation v1 from 'b87789c58-mfrhr': 1`):

`curl ${GATEWAY_URL}`{{execute T1}}

**Note:** The command bellow migh return `customer => 503 preference => 503 no healthy upstream`. In that case, **repeat the command** `curl ${GATEWAY_URL}`{{execute T1}} until you see `customer => preference => recommendation v1 from 'b87789c58-mfrhr': 1`

