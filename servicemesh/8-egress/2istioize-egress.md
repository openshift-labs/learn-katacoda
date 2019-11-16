Let’s redirect all traffic to recommendation:v3.

`istioctl create -f ~/projects/istio-tutorial/istiofiles/destination-rule-recommendation-v1-v2-v3.yml -n tutorial; \
istioctl create -f ~/projects/istio-tutorial/istiofiles/virtual-service-recommendation-v3.yml
`{{execute interrupt T1}}

Then access to the service:

**IMPORTANT**: *Since no Egress service entry has been registered to access an external site, the timeout error is thrown after 5 seconds of trying to access to the site.*

`curl -m 5 http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute interrupt T1}}

You should see an error messsage: `curl: (28) Operation timed out after 5000 milliseconds with 0 bytes received`

Let’s fix it by registering a service entry to allow access to httpbin.

Open the file `istiofiles/service-entry-egress-worldclockapi.yml`{{open}}.

Note that this `ServiceEntry` allows you to access the host `worldclockapi.com` in the port `80`.

Apply this file executing the following command:

`istioctl create -f ~/projects/istio-tutorial/istiofiles/service-entry-egress-worldclockapi.yml -n tutorial`{{execute T1}}

Now you can execute `curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute T1}}

and you should see the following message: `customer => preference => Mon, 16 Jul 2018 12:03:38 GMT recommendation v3 from '7b445dd469-j6rkg': 1`

## Clean up

Don't forget to remove the `virtualservice` and `destinationrule` executing `~/projects/istio-tutorial/scripts/clean.sh`{{execute interrupt T1}}
