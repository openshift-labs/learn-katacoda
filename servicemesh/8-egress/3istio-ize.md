Open the file `istiofiles/egress_httpbin.yml`{{open}}.

Note that it allows access to `httpbin.org` on the port `80`

Let's apply this file.

`istioctl create -f ~/projects/istio-tutorial/istiofiles/egress_httpbin.yml -n istioegress`{{execute T1}}

Check the existing `egressrules`: `istioctl get egressrules`{{execute T1}}

Try the microservice by typing `curl http://egresshttpbin-istioegress.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute T1}}

Alternativally you can shell into the pod by getting its name and then using that name with oc exec

`oc exec -it $(oc get pods -o jsonpath="{.items[*].metadata.name}" -l app=egresshttpbin,version=v1) -c egresshttpbin /bin/bash`{{execute T1}}

Try the following commands:

- `curl localhost:8080`{{execute T1}}
- `curl httpbin.org/user-agent`{{execute T1}}
- `curl httpbin.org/headers`{{execute T1}}

Exit from the pod: `exit`{{execute T1}}

## Istio-ize egressgithub

You can create YAML files from command lines by passing it to `istioctl` via `cat <<EOF |`

Execute:

```
cat <<EOF | istioctl create -f -
apiVersion: config.istio.io/v1alpha2
kind: EgressRule
metadata:
    name: google-egress-rule
    namespace: istioegress
spec:
    destination:
        service: www.google.com
    ports:
      - port: 443
        protocol: https
EOF
```{{execute T1}}

and shell into the github pod for testing google access: `oc exec -it $(oc get pods -o jsonpath="{.items[*].metadata.name}" -l app=egressgithub,version=v1) -c egressgithub /bin/bash`{{execute T1}}

Try to access google: `curl http://www.google.com:443`{{execute T1}}

Exit from the pod: `exit`{{execute T1}}

Open the file `istiofiles/egress_github.yml`{{open}}.

Note that it allows access to `api.github.com` on the port `443`

Now, apply the egressrule for github:

`istioctl create -f ~/projects/istio-tutorial/istiofiles/egress_github.yml -n istioegress`{{execute T1}}

And execute the Java code that hits api.github.com/users `curl http://egressgithub-istioegress.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute T1}}

## Clean up

Remove the egress rules

`istioctl delete egressrule httpbin-egress-rule google-egress-rule github-egress-rule -n istioegress`{{execute T1}}