Modifying ConfigMaps can also be done in a few different ways. For this step
we will use the OpenShift Web Console to graphically (and manually) update the ConfigMap. This
could also be done programmatically if desired. Follow the below steps:

**1. Update the ConfigMap content:**

Return to the OpenShift Web Console by clicking the tab:

![OpenShift Console Tab](/openshift/assets/middleware/rhoar-getting-started-nodejs/openshift-console-tab.png)

Select the example application as before to open the Overview page for the project:

![Overview](/openshift/assets/middleware/rhoar-getting-started-nodejs/overview-populated.png)

From here, navigate to _Resources_ -> _Config Maps_ to display a list of ConfigMaps:

![ConfigMaps](/openshift/assets/middleware/rhoar-getting-started-nodejs/configmaps.png)

Click on the `app-config` ConfigMap to display the ConfigMap details:

![ConfigMaps](/openshift/assets/middleware/rhoar-getting-started-nodejs/configmap-detail.png)

To change the value for `message`, click on the _Actions_ button and select _Edit_:

![ConfigMaps](/openshift/assets/middleware/rhoar-getting-started-nodejs/configmap-edit.png)

Replace the value of `message` by carefully changing the existing text. You can use `%s` as a placeholder for the name
to be included in the greeting:

![ConfigMaps](/openshift/assets/middleware/rhoar-getting-started-nodejs/configmap-edit-replace.png)

Once complete, click _Save_ to save the updated value.

**2. Verify the application has updated:**

Return to the application and type in your name into the _Name_ field once again. Click the **Invoke** button
to verify that the message returned is the same as what you supplied in the ConfigMap:

![ConfigMaps](/openshift/assets/middleware/rhoar-getting-started-nodejs/configmap-verify.png)

## Congratulations!

Without changing a single line of code you were able to update the behavior of the application using
OpenShift ConfigMaps.
