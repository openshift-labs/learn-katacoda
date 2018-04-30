# Create Timestamp Function

**1. Create a simple Timestamp JavaScript function**

First, we need to create JavaScript file, click on the link below to create an empty file called **timestamp.js** in the directory **/root/projects/ocf** : ``timestamp.js``{{open}}

Once the created file is opened in the editor, you can then copy the content below into the file (or use the `Copy to editor` button):

<pre class="file" data-filename="/root/projects/ocf/timestamp.js" data-target="replace">
function main(params) {
  var date = new Date();
  console.log("Invoked at: " + date.toLocaleString());
  return { message: "Invoked at: " + date.toLocaleString() };
}
</pre>
Take a minute and review the `timestamp.js`. The function is pretty simple logging a message with the timestamp to the console and also returning that same message.

**2. Deploy the function**

Let's now deploy the function called **timestamp** to OpenWhisk:

``cd /root/projects/ocf/``{{execute}}

``wsk -i action create timestamp timestamp.js``{{execute}}

Lets check if the function is created correctly:

``wsk -i action list | grep timestamp``{{execute}}

The output of the command should show something like:

```sh
/whisk.system/timestamp                                  private nodejs:6
```
