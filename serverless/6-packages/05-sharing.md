# Sharing Packages

When we're done with our package and we're ready to share it, we need to publish it.  We can check the status of our package like this:

``wsk -i package get conversions publish``{{execute}}

This output shows us that our package has not yet been published:

```
ok: got package conversions, displaying field publish
false
```

Publishing a package is done via a simple command:

``wsk -i package update conversions --shared yes``{{execute}}

Again, we can check the status of our package and see that it has now been published:

``wsk -i package get conversions publish``{{execute}}

gives us this:

```
ok: got package conversions, displaying field publish
true
```

If we take a look at the package listing again, we'll see our new package is listed as shared like the sample packages are:

```
packages
/whisk.system/conversions                                              shared
/whisk.system/kelvin                                                   private
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

Note that the `kelvin` package is still private.  The package bindings must be published separately.

Should you change your mind and need to unpublish a package, simply pass `no` where we passed `yes` above:

``wsk -i package update conversions --shared no``{{execute}}

Getting the listing of packages again will show that our package is once again private:

```
packages
/whisk.system/conversions                                              private
/whisk.system/kelvin                                                   private
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
