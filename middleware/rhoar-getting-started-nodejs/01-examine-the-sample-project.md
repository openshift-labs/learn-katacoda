The sample project shows the components of a Node.js project using Node.js and NPM best practices.

The app implements a simple RESTful microservice which implements a greeting service (that simply returns a
Hello greeting).

**1. Inspect the application code**

Click the links below to open each file and inspect its contents:

* `package.json`{{open}} - Metadata about the project: name, version, dependencies, and other information needed to build and maintain the project.
* `app.js`{{open}} - Main logic of the sample application defining REST endpoints and application runtime configuration.
* `app-config.yml`{{open}} - Content used to initially populate the OpenShift ConfigMap, which the sample app will access at runtime.
* `public/index.html`{{open}} - Simple web UI to access the greeting service.

Review the content a bit and notice that there are some `TODO` comments in the code. Do not remove them! The comments are used as marker and without them you will not be able finish the scenario.

The `/api/greeting` API defined in `app.js` returns a simple message including an optional name. You will modify this file later on.

**2. Install Dependencies**

Dependencies are listed in the `package.json` file and declare which external projects this sample app requires.
To download and install them, run the following command:

``npm install``{{execute HOST1}}

> You can click on the above command (and all others in this scenario) to automatically copy it into the terminal and execute it

It will take a few seconds to download, and you should see a final report such as `added 774 packages in 9.79s`.

**3. Run the application**

Before we add code to the project you should build and test that current application starts as it should.

Since this is a working application, run the application locally using `npm`:

``npm start``{{execute HOST1}}

At this stage the application doesn't really do anything but after a while you will see:

```console
> nodejs-configmap@1.0.0 start /root/projects/rhoar-getting-started/nodejs
> node .
```

**3. Test the application**

To begin, click on the **Local Web Browser** tab in the console frame of this browser window. This will open the another tab or window of your browser pointing to port 8080 on your client.

![Local Web Browser Tab](/openshift/assets/middleware/rhoar-getting-started-nodejs/web-browser-tab.png)

You should now see a html page that looks like this

![App](/openshift/assets/middleware/rhoar-getting-started-nodejs/app.png)

This indicates that the app started up correctly. Type in your name into the Name field and click **Invoke**. The default
hard-coded greeting is returned.

![Hardcode](/openshift/assets/middleware/rhoar-getting-started-nodejs/hardcode.png)

**4. Stop the application**

Before moving on, click in the terminal window and then press CTRL-C to stop the running application!

## Congratulations

You have now successfully executed the first step in this scenario.

Now you've seen how you with a few lines of code one can create a simple RESTful HTTP Server capable of serving static content using Node.js.

In next step of this scenario we will deploy our application to OpenShift Container Platform.
