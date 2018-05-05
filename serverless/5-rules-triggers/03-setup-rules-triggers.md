# Setup Rules And Triggers

In this step, you will go back to your **first Terminal tab** and setup a trigger and a rule to invoke the timestamp
function periodically. If you have not clicked on the first terminal tab, do so now. 

**1. Setup `every-2-seconds` Trigger.**

This trigger uses the built-in alarm package feed to fire events every 2 seconds. This is specified through cron syntax
in the `cron` parameter. The `maxTriggers` parameter ensures that it only fires for 200 seconds (100 times), rather than
indefinitely.  To create the trigger enter the following command:

``
wsk -i trigger create every-2-seconds \
    --feed  /whisk.system/alarms/alarm \
    --param cron '*/2 * * * * *' \
    --param maxTriggers 100
``{{execute T1}}

**2. Create `invoke-periodically` Rule.**

This rule shows how the `every-2-seconds` trigger can be declaratively mapped to the `timestamp.js` action. 
Notice that it's named somewhat abstractly so that if we wanted to use a different trigger 
(perhaps something that fires every minute instead) we could still keep the logical name. To create the rule
enter the following command:

``
wsk -i rule create \
    invoke-periodically \
    every-2-seconds \
    timestamp
``{{execute T1}}

At this point, you can click on the **Terminal 2 tab** to check the activation polling to confirm that the timestamp
action is invoked by the trigger every 2 seconds.  You should see something like this:

```sh
Activation: 'every-2-seconds' (3e255c2d54534764a55c2d5453676405)
[
    "{\"statusCode\":0,\"success\":true,\"activationId\":\"78cc6219bf3544bb8c6219bf3514bbf6\",\"rule\":\"whisk.system/invoke-periodically\",\"action\":\"whisk.system/timestamp\"}"
]

Activation: 'timestamp' (78cc6219bf3544bb8c6219bf3514bbf6)
[
    "2018-04-19T23:23:01.87488594Z  stdout: Invoked at: 4/19/2018, 11:23:01 PM"
]
```
Now click on the **first Terminal tab** and delete the `invoke-periodically` rule by doing:

``wsk -i rule delete invoke-periodically``{{execute T1}}

When you go back to the **Terminal 2 tab**, you will see that the action invocations have stopped.
