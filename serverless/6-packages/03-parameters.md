# Parameters


### Action Parameters

If a function takes a lot of parameters, invoking it can get verbose quite quickly.  Fortunately, if those parameter values are often the same, we can define defaults for those parameters and skip passing them at invocation time.

In our case, we will most often want our results in Celsius so let's define a default parameter for the `target`.

``wsk -i action update conversions/temperature --param target C``{{execute}}

Running this command will give you the output of

``ok: updated action conversions/temperature``

Now we can optionally pass the `target` parameter only when we do *not* want the results in Celsius:

``wsk -i action invoke --blocking --result conversions/temperature --param temperature 212 --param scale F``{{execute}}

This gives us our expected response:

```
{
    "result": "212F is 100C"
}
```

We can take it a step further, of course.  If Celsius is our default target temperature scale, it stands to reason that our default initial 
scale is Fahrenheit.  So let's add a default for that one, too.

`NOTE`:  Parameter definitions are not cumulative.  Adding any new default values will overwrite existing definitions.  If you define new default parameter values, you'll have to include any previous definitions.

``wsk -i action update conversions/temperature --param target C --param scale F``{{execute}}

Now we have two default parameters defined and can skip them entirely when we invoke our Action:

``wsk -i action invoke --blocking --result conversions/temperature --param temperature 212``{{execute}}

Of course, we can still supply those parameters whenever we wish to override the default values:

``wsk -i action invoke --blocking --result conversions/temperature --param temperature 100 --param scale C --param target K``{{execute}}

This will assumed the default `scale` of Celsius for the input and give us this result:

```
{
    "result": "100C is 373.15K"
}
```

### Package Parameters

Default parameter values can also be defined on packages.  These values are passed on all Actions defined in the package.  To see this in action, let's reset our temperature conversion Action.  First, we'll delete and recreate our Action:

```
wsk -i action delete conversions/temperature
wsk -i action update conversions/temperature temperature.js
```{{execute}}

We can verify that our default parameters are now gone:

``wsk -i action invoke --blocking --result conversions/temperature --param temperature 212``{{execute}}

This will give you a nonsense response:

```
{
    "result": "NaN is nullundefined"
}
```

As you can see, without those other two parameters the output becomes unintelligible.  Now we can add those defaults to the package.  It 
looks essentially the same except we're going to update the package and not the Action itself:

``wsk -i package update conversions --param target C --param scale F``{{execute}}

We can now test again to see that our default parameter values are, indeed, getting passed along:

```
wsk -i action invoke --blocking --result conversions/temperature --param temperature 212
wsk -i action invoke --blocking --result conversions/temperature --param temperature 212 --param target K
```{{execute}}

As you can see from the output, we get the same as results as we did earlier.  These default parameters and values are passed *every* Action in a package so take care when defining them at this level.

# Next

Next, we'll take a look at some more sophisticated options available with packages.
