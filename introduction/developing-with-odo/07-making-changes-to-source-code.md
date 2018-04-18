First we start the `odo` tool to watch for changes on the file system

`odo watch &`{{execute}}

it will be started in background so we can keep using this terminal window

now, edit the file `index.php`

`sed -i "s/<h1 class=\"text-center\">/<h1 class=\"text-center\">Counter: /" index.php`{{execute}}

and wait a second, as we do just a very small change in a super-virtual environemnt there is a delay 
for `odo` to pick up the change.
However, one it sees the file changed, it will automatically push the changes to the container.

Now you we can reload the page and there is going to be the text `Counter: `.
