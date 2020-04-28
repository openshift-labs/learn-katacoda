In this tutorial, we are going to build a simple Python app, using Thoth s2i build process and use Thoth's provenance check in the process. 

## Why to use Thoth provenance check in s2i build process?

For those who are new to this [s2i](https://docs.openshift.com/container-platform/3.11/using_images/s2i_images/python.html) refers to the Source to image process which
bundles your source code to a image that can be run on OpenShift. 
The provenance check is done against Pipfile and Pipfile.lock, which are expected as an input to Thoth. The output is a structured report (with metadata) that states issues found in the application stack. Currently reported issues are of the following categories:
 - `ERROR/ARTIFACT-DIFFERENT-SOURCE` - reported if a package/artifact is installed from a different package source index in comparision to the configured one

 - `INFO/ARTIFACT-POSSIBLE-DIFFERENT-SOURCE` - reported if a package/artifact can be installed from a different package source index in comparision to the configured one

 - `WARNING/DIFFERENT-ARTIFACTS-ON-SOURCES` - there are present different artifacts on the package source indexes and configuration does not state explicitly which package source index should be used for installing package - this warning recommends explictly stating package source index to guarantee the expected artifacts are used

 - `ERROR/MISSING-PACKAGE` - the given package was not found on package source index (the configured one or any of other package source indexes available)

 - `ERROR/INVALID-ARTIFACT-HASH` - the artifact hash that is used for the downloaded package was not found on the package source index - possibly the artifact has changed over time (dangerous) or was removed from the package source index

You can find more about provenance checks, and how the provenance check reports are structured here - [Link](https://thoth-station.ninja/docs/developers/adviser/provenance_checks.html)

You can find a list of base images which you can use with Thoth in [s2i-thoth repository](https://github.com/thoth-station/s2i-thoth) 
with detailed instructions on how to use Thoth in the OpenShift’s s2i process. 
The container images are hosted at - 
[quay.io](quay.io/organization/thoth-station) with the 
prefix s2i.

We are going to discover more about it in the next step how you can customize the process.

In this demo, we are going to use an Openshift 4.2 playground.<br>
We are operating our services on the MassOpen.cloud [#operatefirst](https://massopen.cloud/connected-initiatives/operate-first)