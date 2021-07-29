In this tutorial, we are going to build a simple Python app, using Thoth s2i.
Thus getting intelligent recommendation on the software stack during the build process.

## Why to use Thoth s2i build process?

For those who are new to this [Source-to-Image(s2i)](https://docs.openshift.com/container-platform/latest/openshift_images/using_images/using-s21-images.html) refers to the Source to image process which
bundles your source code to a image that can be run on OpenShift. 

So when you use, Thoth s2i build process instead of the normal s2i build process, 
Thoth produces recommendations targeting your specific hardware configuration you 
use to run your application inside the cluster (e.g. specific GPU available in 
the cluster).

You can find a list of base images which you can use with Thoth in [s2i-thoth repository](https://github.com/thoth-station/s2i-thoth) 
with detailed instructions on how to use Thoth in the OpenShift’s s2i process. 
The container images are hosted at - 
[quay.io](quay.io/organization/thoth-station) with the 
prefix s2i.

We are going to discover more about it in the next step how you can customize the process.

In this demo, we are going to use an Openshift 4.7 playground.<br>
We are operating our services on the MassOpen.cloud [#operatefirst](https://massopen.cloud/connected-initiatives/operate-first)