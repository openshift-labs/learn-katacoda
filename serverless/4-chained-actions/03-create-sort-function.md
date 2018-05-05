# Create the Sort Function

The second step in our sequence will accept a JSON document containing the list of words to sort and emit the sorted list as another JSON document to be passed to the next step in our sequence.
 
 **1. Create the sort function**
 
For this function, we're going to use a different language.  This step will use python to accept the JSON document and sort the list of words our previous function emitted.  Let's return to our main directory and create a new project for the second function of our sequence.
 
```mkdir ~/projects/sorter
cd ~/projects/sorter
```{{execute}} 
 
 
We need to create our python script for function.  Let's open ``sorter/sorter.py``{{open}} and update it as shown below:
 
<pre class="file" data-filename="sorter/sorter.py" data-target="replace">
def main(args):
    return {"result": sorted(args["result"]) }
</pre>

**2.  Create the Action**

For this action we can simply publish the python script by itself:

``wsk -i action create sequence/sorter sorter.py``{{execute}}

# Next

That's it for this step.  We have one more Action to create before we're truly ready.
