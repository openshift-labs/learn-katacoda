Welcome! In this section we will be exploring the `kustomize` CLI and the
capabilities built into the `kubectl` command.

## Exploring the Kustomize CLI

The `kustomize` CLI should have been installed as part of the lab
setup. Verify that it has been installed.

`kustomize version --short`{{execute}}

This should display the version, it should look something like this.

```shell
{kustomize/v4.0.5  2021-02-13T21:21:14Z  }
```

Kustomize, at its core, is meant to build native Kubernetes manifests
based on YAML, while leaving the original YAML in tact. It achives this
in a "template-less" templating format. This is done by providing a `kustomization.yaml` file.

We will be focusing on two sub-commands the `build` command and the
`edit` command.

The `build` command takes the YAML source (via a path or URL) and creates
a new YAML that can be piped into `kubectl create`. We will work with
an example in the `~/resources/openshift-gitops-examples/components/kustomize-build/` directory.

`cd ~/resources/openshift-gitops-examples/components/kustomize-build/`{{execute}}

Here you should see two files, a `kustomization.yaml` file and a `welcome.yaml` file

`ls -l`{{execute}}

Taking a look at the `openshift-gitops-examples/components/kustomize-build/welcome.yaml`{{open}}
file shows nothing special. Just a standard Kubernetes manifest.

What if, for example, we wanted to add a `label` to this manifest without editing it? This is where the `openshift-gitops-examples/components/kustomize-build/kustomization.yaml`{{open}} file comes in.

As you can see in the output there isn't much. The two sections for this
example are the `resources` and the `patchesJson6902` sections.

`resources` is an array of individual files, directories, and/or URLs where other manifests are stored. In this example we are just loading in one file. The [`patchesJson6902` is a patching RFC](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/patchesjson6902/) that `kustomize` supports. As you can see, in the `patchesJson6902` file, I am adding a label to this manifest.

> **NOTE** You can read about what options are available for patching in the [official documentaion site](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/)

Build this manifest by running: `kustomize build .`{{execute}} , and
you can see that the new label got added to the manifest!

You can use the `kustomize edit` command instead of writing YAML. For
example, you can change the image tag this `Deployment` uses from `latest`
to `ffcd15` by running the following:

`kustomize edit set image quay.io/redhatworkshops/welcome-php:ffcd15`{{execute}}

This will update the
`openshift-gitops-examples/components/kustomize-build/kustomization.yaml`{{open}} file with a
`images` section. Now when you run `kustomize build .`{{execute}} -
you should see not only the new label but also the new `ffcd15` image tag.

> **NOTE** You may have to close the `kustomization.yaml` tab and re-open it to see the changes.

You can see how you can take existing YAML and modify it for
your specific environment without the need to copy or edit the original.

Kustomize can be used to write a new YAML file or be pipped into
the `kubectl` (or `oc`) command. Example:

```shell
kustomize build . | oc apply -f -
```

## Exploring Kustomize with Kubectl

Since Kubernetes 1.14, The `kubectl` command (and by extention the
`oc` cli) has support for Kustomize built in.  You can see this by
running the `kubectl kustomize --help`{{execute}} command.

This runs the `kustomize build` command. You can see this by running: `kubectl kustomize`{{execute}}

Although you can use this to pipe it into the apply command, you
don't have to. The `kubectl apply` command has the `-k` option that
will run the build before it applies the manifest.

To test this out, first create a project: `oc new-project kustomize-test`{{execute}}

Next make sure you are on the project: `oc project kustomize-test`{{execute}}

Finally run the command to build and apply the manifests: `kubectl apply -k ./`{{execute}}

> **NOTE** You can pass not only directories, but URLs as well. The
> only requirement is that you have a `kustomization.yaml` file in
> the path.

This should create the deployment and you should see the pods running in the namespace: `kubectl get pods -n kustomize-test`{{execute}}

You can see the deployment was created with the additional labels: `kubectl get deployment welcome-php -o jsonpath='{.metadata.labels}' | jq -r`{{execute}}

Also, the image was updated based on the customization that was made: `kubectl get deploy welcome-php  -o jsonpath='{.spec.template.spec.containers[].image}{"\n"}'`{{execute}}

As you can see `kustomize` can be a powerful tool.
