# OpenShift learning on Katacoda

This is the content that appears on learn.openshift.com. If you have any questions ping Michael Hausenblas or raise an issue here.

## Contributions

First, you want to fork this repo and sign up at [Katacoda](https://katacoda.com/login) with your GitHub handle.

For each scenario, please do the following:

1. Raise an issue, describing the scenario. It will be assigened to you then.
1. Work on the scenario, try it out in your own environment `https://www.katacoda.com/$GITHUBHANDLE`
1. When you're satisfied, send in a pull request mentioning the issue you created in the first step.
1. Next, get two reviews (two thumbs up) from [OSEVG](mailto:osevg@redhat.com) team members by mentioning @mhausenblas on your issue.
1. Once your scenario has been reviewed, an OSEVG team member will merge it and it will appear on learn.openshift.com

## Content

A few things concerning the layout:

* Create a separate directory for your scenario.
* Follow the naming convention for each step, see [introduction/deploying-images](https://github.com/openshift-evangelists/intro-katacoda/tree/master/introduction/deploying-images) for an example.
* If you have images you want to use in the instructions, you must place them into [assets/introduction](https://github.com/openshift-evangelists/intro-katacoda/tree/master/assets/introduction). Please make a directory matching your scenario name so we can associate the files with the right scenario.
* If you need assets copied into the node to be usable from the shell, you must place them into the `assets/` directory in your scenario, see [introduction/transferring-files/assets](https://github.com/openshift-evangelists/intro-katacoda/tree/master/introduction/transferring-files/assets) for an example. Note that files to be copied also must be listed in your `index.json` under the `assets` key, see [introduction/transferring-files/index.json](https://github.com/openshift-evangelists/intro-katacoda/blob/master/introduction/transferring-files/index.json) for an example.

## Resources

* [Katacoda docs](https://www.katacoda.com/docs)
* [Status page](https://openshift.status.katacoda.com/)
