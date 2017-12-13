Congratulations!  You just finished learning the basics of how to get started with the OpenShift Container Platform.  Feels good doesn't it?

## What's next?

At this point you are probably itching to keep working with OpenShift as you have had a glimpse of the power this can bring to your own applications.  We are currently working on more advanced tutorials that will be hosted here but in the meantime, you can certainly run your own version of OpenShift or use a hosted model.  You are welcome to use one of the following options:

### Minishift

Minishift is a complete OpenShift environment that you can run on your local machine.  The project supports Windows, OS X, and the Linux operating system.  To find more about minishift, visit http://www.openshift.org/vm

### *oc cluster up*

oc cluster up is a command provided by the oc client tool.  It configures and runs an openshift environment running inside of the native docker system for your operating system.  It supports Windows, OS X, and the Linux operating sytems.  For more information, visit https://github.com/openshift/origin/blob/master/docs/cluster_up_down.md

If you decide to try out *oc cluster up*, and you should, I would also suggest that you take a look at a wrapper script that was created to make life a little bit easier for you called *oc cluster wrapper*.  This wrapper provides functionality such as the ability to have different profiles, persistent volume management and other great features.  You can find more information at the official git repository at https://github.com/openshift-evangelists/oc-cluster-wrapper


### OpenShift Online 

The OpenShift team provides a hosted environment which includes a free starter plan which you can use to develop and test applications for OpenShift. You can find details for OpenShift Online and sign up at https://www.openshift.com/pricing/index.html

### OpenShift Dedicated

You can also let Red Hat host an OpenShift instance for you on a public cloud.  This is an ideal scenario for larger teams that doesn't want to deal with the operational aspects or running a full environment.  To find out more, visit https://www.openshift.com/dedicated/

