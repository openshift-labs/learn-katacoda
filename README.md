# OpenShift learning on Katacoda

This is the content that appears on learn.openshift.com. If you have any questions raise an issue here.

## Contributions

First, you want to fork this repo and sign up at [Katacoda](https://katacoda.com/login) with your GitHub handle.

For each scenario, please do the following:

1. Work on the scenario, try it out in your own environment `https://www.katacoda.com/$GITHUBHANDLE`
1. When you're satisfied, send in a pull request mentioning the issue you created in the first step.
1. Next, get two reviews/thumbs up from team members (mention @btannous or @jdob on your issue if you don't see activity within a couple of days)
1. Once your scenario has been reviewed, we will merge it and it will appear on learn.openshift.com

## Delivering a workshop?

**IMPORTANT:** If you are delivering a workshop please ensure that you have alerted the Katacoda team a minimum of **48 hours** before the start of the event, but ideally a full week ahead of time. Without this, we cannot guarantee capacity for everyone. If you are a Red Hat employee who needs to schedule a workshop using the learn.openshift.com scenarios, please contact osevg@redhat.com for information on how to set that up.

## Content

### Categories

There are currently several top-level categories. Each category has a pathway file to define the order on the page. The homepage pathway file is the top-level file, and it points to each of the catgories. You can find the associated pathway files for each category in the top-level directory of the repository. 

* Homepage Pathway: https://github.com/openshift-labs/learn-katacoda/blob/master/homepage-pathway.json

The Using the Cluster pathway is a good example to look at to understand how category pathways are structured:

* Using the Cluster Pathway: https://github.com/openshift-labs/learn-katacoda/blob/master/using-the-cluster-pathway.json

`pathway_id` indicates which directory the scenario content can be found in. Let's look at the first entry in that file:

```
{
        "external_link": "https://learn.openshift.com/introduction/cluster-access/",
        "pathway_id": "introduction",
        "course_id": "cluster-access",
        "title": "Logging in to an OpenShift Cluster"
 }
 ```
 
* Content: https://github.com/openshift-labs/learn-katacoda/tree/master/introduction/cluster-access
* Assets: https://github.com/openshift-labs/learn-katacoda/tree/master/assets/introduction/cluster-access-44


### Creating a scenario

* Create a directory for your scenario in the respective category directory. If you are unsure about which category to use, @btannous and @jdob can help.
* Follow the naming convention for each step
* If you have images you want to use in the instructions, you must place them into assets. Please make a directory matching your scenario name so we can associate the files with the right scenario.
* If you need assets copied into the node to be usable from the shell, you must place them into the `assets/` directory in your scenario. Note that files to be copied also must be listed in your `index.json` under the `assets` key.


### Content admins

To promote a scenario to the public, add it to the pathway file. Scenarios in each directory are accessible without being in the pathway file, but you need to know the full path to access them.

To add the scenario to the dashboard/homepages, include a reference in the pathway file the format of:

```
https://learn.openshift.com/<category-directory-name>/<scenario-directory-name>/
```

For example; https://learn.openshift.com/middleware/fis-deploy-app/

To add a new category create a pathway/scenario folder structure similar to introduction and middleware. Add the category to the homepage by editing https://github.com/openshift-evangelists/intro-katacoda/blob/master/homepage-pathway.json

## Resources

* [Katacoda Examples](https://katacoda.com/scenario-examples)
* [Status page](https://openshift.status.katacoda.com/)
