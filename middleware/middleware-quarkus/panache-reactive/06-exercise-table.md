Now that we have our app running on OpenShift, let's see what we can do.

Click to [access the graphical frontend which includes our DataTable](http://people-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com)

It should look like:

![Web Console Overview](/openshift/assets/middleware/quarkus/panache-reactive-datatable.png)

Notice the total number of records reported at the bottom. Type in a single letter, e.g. `F` in the search box and see how responsive the app is. Type additional letters to narrow the search. Rather than having all 10k records loaded in the browser, DataTable makes a call back to our `/person/datatable` REST endpoint to fetch only those records that should be shown, based on page size, current page you're looking at, and any search filters. With a page size of `10` each REST call will only return up to 10 records, no matter how many there are in the database.

Skip around a few pages, try some different searches, and notice that the data is only loaded when needed. The overall performance is very good even for low-bandwidth connections or huge data sets.

When you are done, return to the first Terminal, press `CTRL-C` to stop the running Quarkus app (or click the `clear`{{execute T1 interrupt}} command to do it for you).

# Extra Credit
There are [many other features of DataTables](https://datatables.net/manual/server-side) that could be supported on the server side with Quarkus and Panache. For example, when our endpoint is accessed, the set of columns to order on is also passed using the `order` and `columns` arrays, which we do not cover in this scenario. If you have time, try to add additional code to support these incoming parameters and order the resulting records accordingly!

# Open the solution in an IDE in the Cloud!
Want to continue exploring this solution on your own in the cloud? You can use the free [Red Hat CodeReady Workspaces](https://developers.redhat.com/products/codeready-workspaces/overview) IDE running on the free [Red Hat Developer Sandbox](http://red.ht/dev-sandbox). [Click here](https://workspaces.openshift.com) to login or to register if you are a new user. This free service expires after 30 days, but you can always enable a new free 30-day subscription.

Once logged in, [click here](https://workspaces.openshift.com/f?url=https://raw.githubusercontent.com/openshift-katacoda/rhoar-getting-started/solution/quarkus/panache-reactive/devfile.yaml) to open the solution for this project in the cloud IDE. While loading, if it asks you to update or install any plugins, you can say no.

# Fork the source code to your own GitHub!
Want to experiment more with the solution code you just worked with? If so, you can fork the repository containing the solution to your own GitHub repository by clicking on the following command to execute it:

`/root/projects/forkrepo.sh`{{execute T1}}
- Make sure to follow the prompts. An error saying `Failed opening a web browser at https://github.com/login/device exit status 127` is expected.
- [Click here](https://github.com/login/device) to open a new browser tab to GitHub and paste in the code you were presented with and you copied.
- Once done with the GitHub authorization in the browser, close the browser tab and return to the console and press `Enter` to complete the authentication process.
- If asked to clone the fork, press `n` and then `Enter`.
- If asked to confirm logout, press `y` and the `Enter`.

   > **NOTE:** This process uses the [GitHub CLI](https://cli.github.com) to authenticate with GitHub. The learn.openshift.com site is not requesting nor will have access to your GitHub credentials.

After completing these steps the `rhoar-getting-started` repo will be forked in your own GitHub account. On the `solution` branch in the repo, the `panache-reactive` project inside the `quarkus` folder contains the completed solution for this scenario.

## Congratulations
In this scenario you got a glimpse of the power of Quarkus apps when dealing with large amounts of data.

You also got to experience Quarkus Remote Development, where local changes are immediately reflected in remote applications. You deployed the app to OpenShift and live-coded changes on the fly.

There is much more to Quarkus than this, so keep on exploring additional scenarios to learn more, and be sure to visit [quarkus.io](https://quarkus.io) to learn even more about the architecture and capabilities of this exciting new framework for Java developers.