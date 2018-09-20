# Setup Activation Polling Terminal

In this step, you will open a second terminal window and execute an OpenWhisk command to do activation polling.

**1. Open Second Terminal**

To the immediate right of the terminal tab is a plus sign ![](/openshift/assets/serverless/5-rules-triggers/open-2nd-term.png).  
Click on this plus and choose ``Open New Terminal`` to open a second terminal window.  Once the second terminal opens, enter 
a command to set the path so the wsk command is accessible:

``export PATH="${HOME}/openwhisk/bin:${PATH}"``{{execute T2}}

**2. Start Activation Polling**

Let's now use the OpenWhisk command to start activation polling in this second terminal:

``wsk -i activation poll``{{execute T2}}

The polling should start in the second terminal.  It may or may not show "invokerHealthTestAction0" messages like:

```sh
Activation: 'invokerHealthTestAction0' (f5bca1d1ef334533bca1d1ef333533de)
[]
```

**3 Verify Timestamp Activation**

Now click on the **first Terminal tab** and invoke your timestamp function manually so we can verify that it shows up in the 
activation polling in the second window:

``wsk -i action invoke --blocking timestamp | grep message``{{execute T1}}

This will echo the resulting JSON message to the current window and log the activation in the other window.  We have
grepped just the payload message so you should see something like this:

```sh
"message": "Invoked at: 4/19/2018, 5:38:46 PM"
```

Click on **Terminal 2 tab** to verify that the activation polling shows the execution of the timestamp function.
You should see something like this:

```sh
Activation: 'timestamp' (a9a18cde63964cf7a18cde6396fcf719)
[
    "2018-04-19T17:38:46.626950489Z stdout: Invoked at: 4/19/2018, 5:38:46 PM"
]
```
