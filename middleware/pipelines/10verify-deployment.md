To verify a successful deployment for our application, head back out to the web console by clicking on the Console at the center top of the workshop in your browser.

Click on the Topology tab on the left side of the web console. You should see something similar to what is shown in the screenshot below:

![Web Console Deployed](../../assets/middleware/pipelines/application-deployed.png)

The Topology view of the OpenShift web console helps to show what is deployed out to your OpenShift project visually. As mentioned earlier, the dark blue lining around the _ui_ circle means that a container has started up and running the _api_ application. By clicking on the arrow icon as shown below, you can open the URL for _ui_ in a new tab and see the application running.

![Web Console URL Icon](../../assets/middleware/pipelines/url-icon.png)

After clicking on the icon, you should see the application running in a new tab.

In addition, you can get the route of the application by executing the following command to access the application.

`oc get route vote-ui --template='http://{{.spec.host}}'`{{execute}}

If you want to re-run the pipeline again, you can use the following short-hand command to rerun the last pipelinerun again that uses the same workspaces, params and service account used in the previous pipeline run:

`tkn pipeline start build-and-deploy --last`{{execute}}

Congratulations! You have successfully deployed your first application using OpenShift Pipelines.