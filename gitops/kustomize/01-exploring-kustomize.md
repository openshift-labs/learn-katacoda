Welcome! In this section we will exploring the `kustomize` CLI and the
capabilities built into the `kubectl` command.

## Exploring the Kustomize CLI

The `kustomize` CLI should have been installed as part of the lab
setup. Verify that it has been installed.

`kustomize version --short`{{execute}}

This should display the version, it should look something like this.

```shell
{kustomize/v4.0.1  2021-02-13T21:21:14Z  }
```

Kustomize, at it's core, is meant to build native Kubernetes manifests
based on YAML, while leaving the original YAML in tact. It achives this
in a "templte-less" templating format. This is done by providing a `kustomization.yaml` file.

We will be focusing on two sub-commands the `build` command and the
`edit` command.

The `build` command takes the YAML source (via a path or URL) and creates
a new YAML that can be piped into `kubectl create`. We will work with
an example in the `~/resources/kustomize-build` directory.

`cd ~/resources/kustomize-build`{{execute}}

Here you should see two files, a `kustomization.yaml` file and a `welcome.yaml` file

`ls -l`{{execute}}

Taking a look at the `~/resources/kustomize-build/welcome.yaml`{{open}}
file shows nothing special. Just a standard Kubernetes manifest.

What if, for example, we wanted to add a `label` to this manifest without editing it? This is where the `~/resources/kustomize-build/kustomization.yaml`{{open}} file comes in.

As you can see in the output there isn't much. The two sections for this
example are the `resources` and the `patchesJson6902` sections.

`resources` is an array of individual files, directories, and/or URLs where other manifests are stored. In this example we are just loading in one file. The [`patchesJson6902` is a patching RFC](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/patchesjson6902/) that `kustomize` supports. As you can see, in the `patchesJson6902` file, I am adding a label to this manifest.

> **NOTE** You can read about what options are availble for patching in the [official documentaion site](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/)

Build this manifets by running: `kustomize build .`{{execute}} , and
you can see that the new label got added to the manifest!

You can use the `kustomize edit` command instead of writing YAML. For example, you can change the image tag this Deployment uses by running the following:

`kustomize edit set image quay.io/redhatworkshops/welcome-php:ffcd15`{{execute}}

This will update the
`~/resources/kustomize-build/kustomization.yaml`{{open}} file with a
`images` section. Now when you run `kustomize build .`{{execute}} -
you should see not only the new label but also a new image.

You can see how you can take already existing YAML and modify it for
your specific environment without the need to copy or edit the original.

## Exploring Kustomize with Kubectl