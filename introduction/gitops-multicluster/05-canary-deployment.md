<br>
# Perform a Canary Deployment with Argo CD

In the previous step we have deployed our customized application to multiple clusters, in this lab we are going to perform a Canary deployment.

We will update our application to a new image version on preproduction and after checking that it works as expected, we will push the change to production.

> **NOTE:** We are going to work directly against Git, this is not recommended for production use cases, in production you should consider using a proper CI/CD system and workflow. This example is just for your reference.

## Verifying current versions

You will see that the application is currently running `v0.0.2` version:

* Preproduction: ``curl http://$(oc --context pre -n reverse-words get route reverse-words -o jsonpath='{.spec.host}')``{{execute}}
* Production: ``curl http://$(oc --context pro -n reverse-words get route reverse-words -o jsonpath='{.spec.host}')``{{execute}}

## Modifying Preproduction Application Manifests

1. Update container image version on `pre` branch

    ``
    cd ~/gitops-lab
    git checkout pre
    sed -i "/- name: reverse-words/a\        image: quay.io/mavazque/reversewords:v0.0.3" reversewords_app/overlays/pre/deployment.yaml
    git add reversewords_app/overlays/pre/deployment.yaml
    git commit -m "Pump container image version to v0.0.3"
    git push origin pre
    ``{{execute}}
2. Argo CD will eventually detect the changes and deploy them to preproduction environment, in the interest of time we are going to force the sync so we don't have to wait

    ``argocd app sync pre-kustomized-reverse-words-app``{{execute}}
3. Wait until the Argo CD application reports `Health Status: Healthy`
    
    ``argocd app get pre-kustomized-reverse-words-app``{{execute}}
4. Let's access our `preproduction` application

    * Verify version v0.0.3: ``curl http://$(oc --context pre -n reverse-words get route reverse-words -o jsonpath='{.spec.host}')``{{execute}}
    * Verify health: ``curl http://$(oc --context pre -n reverse-words get route reverse-words -o jsonpath='{.spec.host}')/health``{{execute}}

You should be seeing `v0.0.3` and `Healthy`, that means we can update our production application as well.

## Modifying Production Application Manifests

1. Update container image version on `pro` branch

    ``
    cd ~/gitops-lab
    git checkout pro
    sed -i "/- name: reverse-words/a\        image: quay.io/mavazque/reversewords:v0.0.3" reversewords_app/overlays/pro/deployment.yaml
    git add reversewords_app/overlays/pro/deployment.yaml
    git commit -m "Pump container image version to v0.0.3"
    git push origin pro
    ``{{execute}}
2. Sync Argo CD application

    ``argocd app sync pro-kustomized-reverse-words-app``{{execute}}
3. Wait until the Argo CD application reports `Health Status: Healthy`
    
    ``argocd app get pro-kustomized-reverse-words-app``{{execute}}
4. Access production application

    * Verify version v0.0.3: ``curl http://$(oc --context pro -n reverse-words get route reverse-words -o jsonpath='{.spec.host}')``{{execute}}
    * Verify health: ``curl http://$(oc --context pro -n reverse-words get route reverse-words -o jsonpath='{.spec.host}')/health``{{execute}}

Now we are using the same version on `pre` and `pro` we should now update the base deployment so newer deployments of our application use `v0.0.3` version.