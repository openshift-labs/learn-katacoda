# OpenShift learning on Katacoda

This is the content that appears on learn.openshift.com. If you have any questions ping Michael Hausenblas or raise an issue here.

## Contributions

First, you want to fork this repo and sign up at [Katacoda](https://katacoda.com/login) with your GitHub handle.

For each scenario, please do the following:

1. Create a card on the respective [Trello board](https://trello.com/b/4uOCyBJp/katacoda-red-hat)
1. Work on the scenario, try it out in your own environment `https://www.katacoda.com/$GITHUBHANDLE`
1. When you're satisfied, send in a pull request mentioning the issue you created in the first step.
1. Next, get two reviews/thumbs up from team members (mention @mhausenblas on your issue if you do't see activity within a day)
1. Once your scenario has been reviewed, we will merge it and it will appear on learn.openshift.com

## Content

### Categories

There are currently three categories, [Foundations of OpenShift](https://learn.openshift.com/introduction), [Building Applications On OpenShift](https://learn.openshift.com/middleware) and [OpenShift Playgrounds](https://learn.openshift.com/playgrounds). Each category has its own directory for content, assets and a pathway file to define the order on the page:

* Content: https://github.com/openshift-evangelists/intro-katacoda/tree/master/introduction
* Assets: https://github.com/openshift-evangelists/intro-katacoda/tree/master/assets/introduction
* Pathway: https://github.com/openshift-evangelists/intro-katacoda/blob/master/introduction-pathway.json

### Creating a scenario

* Create a directory for your scenario in the respective category directory.
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

* [Katacoda docs](https://www.katacoda.com/docs)
* [Status page](https://openshift.status.katacoda.com/)
