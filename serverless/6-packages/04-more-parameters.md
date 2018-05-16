# More Parameters

### Parameter files

Using default parameter values is one way to reduce the clutter of invoking Actions with parameters.  However it's only truly useful if there are commonly used default values that can be omitted.  More common is the case where there are several parameters to pass that don't boil down to commonly used default values.  In still other cases, the parameter values might be complex json documents, e.g., that are awkward to pass on the command line.

In these cases, we can use files to hold out parameters and pass that file to our invocation.  Lets start by create a simple JSON file to hold these values.

Create a new file called ``parameters.json``{{open}} and update it reflect the following:

<pre class="file" data-filename="parameters.json" data-target="replace">
{
    "temperature": 0,
    "scale": "K"
}
</pre>

With this file defined, we can invoke our action using just that:

``wsk -i action invoke --blocking --result conversions/temperature --param-file parameters.json``{{execute}}

As you can see below, the JSON gets passed as payload to our Action as if we'd passed each parameter on the command line:

```
{
    "result": "0K is -273.15C"
}
```

Of course, the parameter file is JSON so your input document could be quite complex as well:

```
{
    "city": {
        "id": 5128581,
        "name": "New York",
        "findname": "NEW YORK",
        "country": "US",
        "coord": {
            "lon": -74.005966,
            "lat": 40.714272
        },
        "zoom": 1
    },
    "time": 1489487654,
    "main": {
        "temp": 270.14,
        "pressure": 1012,
        "humidity": 92,
        "temp_min": 267.15,
        "temp_max": 272.15
    },
    "wind": {
        "speed": 5.1,
        "deg": 50,
        "gust": 8.7
    },
    "clouds": {
        "all": 90
    },
    "weather": [{
        "id": 601,
        "main": "Snow",
        "description": "snow",
        "icon": "13n"
    }, {
        "id": 701,
        "main": "Mist",
        "description": "mist",
        "icon": "50n"
    }, {
        "id": 741,
        "main": "Fog",
        "description": "fog",
        "icon": "50n"
    }]
}
```

Content at this scale would be painful to pass on the command line.  Some data might even exceed the operating system's allowable command 
line length.  A parameter file sidesteps both of these issues.

### Package Bindings

In many applications it might be impossible to identify a set of default values for parameters that apply broadly across all uses of an API.  However, it might be possible to identify multiple common uses within which certain patterns can be used to determine a workable set of default parameters.  In these case, we can create a package binding to define default values specific to that particular use case or work flow.

For example, in our temperature conversion package we've been assuming that, absent an input scale, the temperature had been measured in Fahrenheit.  But suppose a group came along that works almost exclusively in Kelvin.  That default now starts to get in the way.  One solution is to create a binding for that package with Kelvin as the default input scale:

``wsk -i package bind /whisk.system/conversions kelvin --param scale K``{{execute}}

This creates a meta-package, of sorts, that binds the parameter names and values before invoking the underlying Actions.  We can see our new package in OpenWhisk:

``wsk -i package get --summary kelvin``{{execute}}

```
package /whisk.system/kelvin: Returns a result based on parameters scale and target
   (parameters: *scale, *target)
 action /whisk.system/kelvin/temperature
   (parameters: none defined)
```

We invoke this binding just like our previous invocations but we use the new binding name instead:

``wsk -i action invoke --blocking --result kelvin/temperature --param temperature 0``{{execute}}

As you can see, this gives us our expected result:

```
{
    "result": "0K is -273.15C"
}
```

# Next

Now that we have defined and refined our package and Action, it's time to share our work with the world.
