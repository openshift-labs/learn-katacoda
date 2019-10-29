We've deployed the first version of our application and tested it by visiting it with a browser. Let's look at how OpenShift and `odo` help make it easier to iterate on that app once it's running.

First, make sure you are still in the `frontend` directory:

`cd ~/frontend`{{execute}}

Now, we will tell `odo` to `watch` for changes on the file system in the background. Note that the `&` is included to run `odo watch` in the background for this tutorial, but it is usually just run as `odo watch` and can be terminated using `ctrl+c`.

`odo watch &`{{execute}}

Let's change the displayed name for our wild west game. Currently, the title is "Wild West Shoot 'em Up!" We will change this to "My App Shoot 'em Up!"

![Application Title](../../assets/introduction/developing-with-odo/app-name.png)

Edit the file `index.html` with a search-and-replace one-liner performed with the Unix stream editor, `sed`:

`sed -i "s/Wild West/My App/" index.html`{{execute}}

There may be a slight delay before `odo` recognizes the change. Once the change is recognized, `odo` will push the changes to the `frontend` component and print its status to the terminal:

```
File /root/frontend/index.html changed
File  changed
Pushing files...
 ✓  Waiting for component to start
 ✓  Copying files to component
 ✓  Building component
```

Refresh the application's page in the web browser. You will see the new name in the web interface for the application.

__NOTE__: If you no longer have the application page opened in a browser, you can recall the url by executing:

`odo url list`{{execute interrupt}}
