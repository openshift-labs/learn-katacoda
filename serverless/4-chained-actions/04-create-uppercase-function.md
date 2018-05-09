# Create the Uppercase Action

This next Action will take each element in the list of words and convert them to uppercase.  When that's done it will emit
a JSON document containing the modified list.

**1.  Create the Javascript Action**

First, let's return to the root and create a new project to hold our Javascript Action:

```
mkdir -p ~/projects/uppercase
cd ~/projects/uppercase
```{{execute}}

Now, **click on the link** to open ``uppercase/uppercase.js``{{open}} and **click on the Copy to Editor** button to create our
uppercase Action:

<pre class="file" data-filename="uppercase/uppercase.js" data-target="replace">
function main(args) {
    return {"result": args["result"].map(s => s.toUpperCase()) }
 }
</pre>

**2.  Create the Action**

For this action we can simply publish the python script by itself:

``wsk -i action create sequence/uppercase uppercase.js``{{execute}}

**3. Verify the Action**

Let's check if the Action is created correctly:

``wsk -i action list | grep sequence``{{execute}}

The output of the command should show something like:

```sh
/whisk.system/sequence/uppercase                                       private nodejs:6
/whisk.system/sequence/sorter                                          private python:2
/whisk.system/sequence/splitter                                        private java
```

**4.  Test the Action**

One again, we can test this action using the output of the last action:

``wsk -i action invoke sequence/uppercase --param-file ~/sorted.json --result``{{execute}}

This will give us our expected output:

```json
{
    "result": [
        "ANTELOPE",
        "CAT",
        "ZEBRA"
    ]
}
```

Here we can see that our output is as expected and we're ready for the next step.

# Next

That's the last Action we need to create.  Next, we'll create the sequence that ties them all together.
