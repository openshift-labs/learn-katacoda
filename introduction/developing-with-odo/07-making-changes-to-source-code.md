We've deployed the first version of our sample application and tested it by visiting it with a browser. Let's look at how OpenShift and `odo` help make it easier to iterate on that app once it's running.

First, we start the `odo` tool to `watch` for changes on the file system in the background:

`odo watch &`{{execute}}

Since we backgrounded the execution of `odo` with the `&` symbol, we can continue to work in the same terminal window. Our current working directory remains the `frontend` component's source code directory.

Let's add a label to the counter display. Edit the file `index.php` with a search-and-replace one-liner performed with the Unix stream editor, `sed`(1):

`sed -i "s/<h1 class=\"text-center\">/<h1 class=\"text-center\">Counter: /" index.php`{{execute}}

In the virtual environment, rather than your local disk, there may be a slight delay before `odo` recognizes the change. Once the change is recognized, `odo` will push the changes to the `frontend` component and print its status to the terminal.

Once it does, refresh the application's page in the web browser. You will see the new label "Counter" that we added to the application's index file.

NOTE: If you no longer have the the application page opened in a browser, you can recall the url by executing:

`odo url list`{{execute}}
