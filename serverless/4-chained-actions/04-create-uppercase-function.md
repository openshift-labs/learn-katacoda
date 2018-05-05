# Create the Uppercase Function

This next function will take each element in the list of words and convert them to uppercase.  When that's done it will emit a JSON document containing the modified list.

**1.  Create the Javascript function**

First, let's return to the root and create a new project to hold our Javascript function:

```
mkdir -p ~/projects/uppercase
cd ~/projects/uppercase
```{{execute}}

Now let's open ``uppercase/uppercase.js``{{open}} and create our uppercase function:

<pre class="file" data-filename="uppercase/uppercase.js" data-target="replace">
function main(args) {
    return {"result": args["result"].map(s => s.toUpperCase()) }
 }
</pre>

**2.  Create the Action**

For this action we can simply publish the python script by itself:

``wsk -i action create sequence/uppercase uppercase.js``{{execute}}

# Next

That's the last Action we need to create.  Next, we'll create the sequence that ties them all together.
