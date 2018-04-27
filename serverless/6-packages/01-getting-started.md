# Getting Started

**1. Browsing existing packages**

Before we start creating our own packages, let's take a look and see what's already there.

``wsk -i package list /whisk.system``{{execute}}

Executing this command will return a result like this:

```
packages
/whisk.system/weather                                                  shared
/whisk.system/websocket                                                shared
/whisk.system/github                                                   shared
/whisk.system/watson-translator                                        shared
/whisk.system/watson-textToSpeech                                      shared
/whisk.system/samples                                                  shared
/whisk.system/utils                                                    shared
/whisk.system/slack                                                    shared
/whisk.system/watson-speechToText                                      shared
/whisk.system/combinators                                              shared
/whisk.system/alarmsWeb                                                private
/whisk.system/alarms                                                   shared
```

These are the default packages installed when Apache OpenWhisk is first installed.  Knowing how to list these packages will help us verify our own packages are being properly created.  We can dig even deeper and see what is in a given package:

``wsk -i package get --summary /whisk.system/alarms``{{execute}}

This will give us this output:

```
package /whisk.system/alarms: Alarms and periodic utility
   (parameters: *apihost, *trigger_payload)
 feed   /whisk.system/alarms/interval: Fire trigger at specified interval
   (parameters: minutes, startDate, stopDate)
 feed   /whisk.system/alarms/once: Fire trigger once when alarm occurs
   (parameters: date, deleteAfterFire)
 feed   /whisk.system/alarms/alarm: Fire trigger when alarm occurs
   (parameters: cron, startDate, stopDate)
```

Here we can see that the `alarms` package contains three feeds.  Additionally, we can see these feeds all take various parameter values. We will look in to how to make use of this kind of information as we proceed.

**2. Creating a package**

For this scenario, we will be creating a set of conversion routines:  temperatures, distances, etc.  So the first step is to create a package to hold all our conversion functions:

``wsk -i package create conversions``{{execute}}

This command should execute quite quickly and seem like nothing was actually done but we can verify our new package was created:

``wsk -i package list | grep conversions``{{execute}}

This will give a result like:

```
/whisk.system/conversions                                              private
```

# Next

With our package created, we can begin to add some functionality.
