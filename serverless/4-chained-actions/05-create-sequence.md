# Create the Sequence

The final step is to group our functions into to a sequence.  This allows us to invoke the first function and let OpenWhisk handle invoking each subsequent Action in turn.


**1.  Create the sequence**
First, let's create that sequence.  The following command will create a sequence called `strings` and will invoke our three Actions.  Each Action will be invoked in the order defined here.

``wsk -i action update strings --sequence sequence/splitter,sequence/uppercase,sequence/sorter``{{execute}}

**2.  Verify the sequence**
With our Actions defined and sequence created, it's time to put them to test.  Using the `wsk` command we can invoke our sequence and pass it some string to process.

``wsk -i action invoke strings --param text "zebra,cat,antelope" --result``{{execute}}

After invoking this command you should get back a response that looks like this:

```
{
    "result": [
        "ANTELOPE",
        "CAT",
        "ZEBRA"
    ]
}
```

# You're done!

In this scenario, we created three different Actions and tied them together in one Action.  OpenWhisk takes care of invoking each step 
and passing the results to each step in our pipeline.  In addition, each Action can be independently updated with out the need to touch 
every other step in the sequence.
