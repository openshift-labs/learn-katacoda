Edit the file `views/index.erb`

`sed -i "s/<h1 class=\"text-center\">/<h1 class=\"text-center\">Counter: /"l>$ cat views/index.erb`{{execute}}

and check the changes

`git diff`

and you will we have added the text `Counter: ` into the file.

Now, let's deploy the code into our app

`ocdev push`{{execute}}

And once the command finishes, check the page with your counter to see the changes.
