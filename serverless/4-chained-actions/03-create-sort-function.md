# Create the Sort Action

The second step in our sequence will accept a JSON document containing the list of words to sort and emit the sorted list as 
another JSON document to be passed to the next step in our sequence.
 
 **1. Create the sort Action**
 
For this Action, we're going to use a different language.  This step will use python to accept the JSON document and sort the list
of words our previous Action emitted.  Let's return to our main directory and create a new project for the second Action of our
sequence.
 
```
mkdir ~/projects/sorter
cd ~/projects/sorter
```{{execute}} 
 
We need to create our python script for Action.  **Click on the link** to open ``sorter/sorter.py``{{open}} and click on the
**Copy to Editor** button to update it as shown below:
 
<pre class="file" data-filename="sorter/sorter.py" data-target="replace">
def main(args):
    return {"result": sorted(args["result"]) }
</pre>

**2.  Create the Action**

For this action we can simply publish the python script by itself:

``wsk -i action create sequence/sorter sorter.py``{{execute}}

**3. Verify the Action**

Let's check if the Action is created correctly:

``wsk -i action list | grep sequence``{{execute}}

The output of the command should show something like:

```sh
/whisk.system/sequence/sorter                                          private python:2
/whisk.system/sequence/splitter                                        private java
```

Here you can now see both actions we've created so far.

**4.  Test the Action**

Using the JSON file we created in the last step, we test our new action in isolation to be sure it's doing what we expect:

``wsk -i action invoke sequence/sorter --param-file  ~/split.json --result | tee ~/sorted.json``{{execute}}

This will give us our expected output:

```json
{
    "result": [
        "antelope",
        "cat",
        "zebra"
    ]
}
```

Note that here, too, we have saved the output so we can test our next step.

# Next

That's it for this step.  We have one more Action to create before we're truly ready.
