# Adding functions

The first Action we're going to create is a simple temperature conversion function.  We'll write a simple javascript that takes two parameters:  the temperature and the scale used.

Let's open ``temperature.js``{{open}} and define our function.

<pre class="file" data-filename="temperature.js" data-target="replace">
function normalize(value, scale) {
    switch(scale) {
        case "C":
            converted = value
            break;
        case "F":
            converted = (value - 32) / 1.8
            break;
        case "K":
            converted = value - 273.15
            break;
        default:
            converted = null
    }

    return converted
}

function main(args) {
    temperature = args.temperature
    scale = args.scale
    target = args.target

    switch (target) {
        case "C":
            converted = normalize(temperature, scale)
            break;
        case "F":
            converted = normalize(temperature, scale) * 1.8 + 32
            break;
        case "K":
            converted = normalize(temperature, scale) + 273.15
            break;
        default:
            converted = null
            break;
    }

    return { "result": temperature + scale + " is " + converted + target }
}
</pre>

Here we have a "simple" temperature converter.  This example has been slightly complicated to make room for later demonstrations.  At any rate, with our function created we need to tell OpenWhisk about it:

```
cd ~/projects
wsk -i action update conversions/temperature temperature.js
```{{execute}}

After running this you should this response:

`ok: updated action conversions/temperature`

With our function defined, let's run some tests to make sure everything is working as expected.  We know our function takes three parameters so we can invoke it like this:

``wsk -i action invoke --blocking --result conversions/temperature --param temperature 212 --param scale F --param target K``{{execute}}

Here we are asking our conversion function to convert 212 Fahrenheit to Kelvin.  The result will look like this:

```
{
    "result": "212F is 373.15K"
}
```
A few other runs shows that everything works as expected:

``wsk -i action invoke --blocking --result conversions/temperature --param temperature 100 --param scale C --param target F``{{execute}}

``wsk -i action invoke --blocking --result conversions/temperature --param temperature -40 --param scale F --param target C``{{execute}}

# Next

At this point, it's not difficult to see how verbose this invocation can get.  In the next step, we'll explore how to mitigate some of that verbosity.
