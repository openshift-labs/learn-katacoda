# Create Simple Greeter Function

**1. Create a simple greeter JavaScript function**

First, we need to create JavaScript file, click on the link below to create an empty file called **greeter.js** in the directory **/root/projects/ocf** : ``greeter.js``{{open}}

Once the created file is opened in the editor, you can then copy the content below into the file (or use the `Copy to editor` button):

<pre class="file" data-filename="/root/projects/ocf/greeter.js" data-target="replace">
function main(params) {
    var name = params.name || 'Guest';
    return {payload: 'Welcome to OpenShift Cloud Functions, ' + name};
}
</pre>
Take a minute and review the `greeter.js`. At this stage it is pretty simple and has only one method that returns a JSON payload like 
```json
{"payload": "Welcome to OpenShift Cloud Functions, Guest"}
```

**2. Deploy the function**

Lets now deploy the function:

``cd /root/projects/ocf/``{{execute}}

``wsk -i action create greeter greeter.js``{{execute}}

Lets check if the function is created correctly:

``wsk -i action list | grep greeter``{{execute}}

The output of the command should show somthing like:

```sh
/whisk.system/greeter                                  private nodejs:6
```

**3. Verify the function**

Having created the function **greeter**, lets now verify the function by invoking it:

``wsk -i action invoke --result greeter``{{execute}}

Executing the above command should return us a JSON payload like:

```json
{"payload": "Welcome to OpenShift Cloud Functions, Guest"}
```
Now invoke the function by **copying the line below and pasting it into the terminal window followed by your name**.

``wsk -i action invoke --result greeter --param name ``

You should get the same respone as before but with your name instead of 'Guest'.  Feel free to repeat this command
several times with different names appended to the end.  

Now, lets see how many times we have invoked this function by dumping the activation log with.  The activation log in 
Apache OpenWhisk is designed with a lazy database view update mechanism that prioritizes invocations over activation
logging.  This means that you currently often have to invoke the ``wsk -i activation list`` command twice with a
pause in between.  So, we will do that with the command below:

``wsk -i activation list > /dev/nul 2>&1; sleep 1; wsk -i activation list | grep greeter``{{execute}}

Now, let's pick an activation and look at it in detail.  First, **copy the line below and paste it into the terminal
window**:

``wsk -i activation get ``

Then, pick one of the activations displayed in your terminal window and **copy the activation ID and paste it after the
command above**.  Hit Enter and you will see something like this:

```sh
ok: got activation 22cea08e45d147868ea08e45d1d78605
{
    "namespace": "whisk.system",
    "name": "greeter",
    "version": "0.0.2",
    "subject": "whisk.system",
    "activationId": "22cea08e45d147868ea08e45d1d78605",
    "start": 1524639089200,
    "end": 1524639089206,
    "duration": 6,
    "response": {
        "status": "success",
        "statusCode": 0,
        "success": true,
        "result": {
            "payload": "Welcome to OpenShift Cloud Functions, Jimbo"
        }
    },
    "logs": [],
    "annotations": [
        {
            "key": "limits",
            "value": {
                "logs": 10,
                "memory": 256,
                "timeout": 60000
            }
        },
        {
            "key": "path",
            "value": "whisk.system/greeter"
        },
        {
            "key": "kind",
            "value": "nodejs:6"
        },
        {
            "key": "waitTime",
            "value": 372
        }
    ],
    "publish": false
}
```
