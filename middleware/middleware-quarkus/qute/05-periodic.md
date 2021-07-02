# Rendering Periodic Reports

Templating engines can be also very useful when rendering periodic reports. We will use the `quarkus-scheduler` extension which you've already added.

## Create Samples

Now let's create a simple `Sample` object that represents a point-in-time of a value (maybe ambient temperature or blood pressure of a patient):

Click `qute/src/main/java/org/acme/Sample.java`{{open}} to open the file. Click **Copy to Editor** to paste in the code:

<pre class="file" data-filename="./qute/src/main/java/org/acme/Sample.java" data-target="replace">
package org.acme;

public class Sample {
    public boolean valid;
    public String name;
    public String data;

    public Sample(boolean valid, String name, String data) {
        this.valid = valid;
        this.name = name;
        this.data = data;
    }

}
</pre>

Now let's ceate a service whose `get()` method returns a random list of samples. Open the file with `qute/src/main/java/org/acme/SampleService.java`{{open}} and click **Copy to Editor** to create the code:

<pre class="file" data-filename="./qute/src/main/java/org/acme/SampleService.java" data-target="replace">
package org.acme;

import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import javax.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class SampleService {
    private static final String[] names = {&quot;James&quot;, &quot;Deepak&quot;, &quot;Daniel&quot;, &quot;Shaaf&quot;, &quot;Jeff&quot;, &quot;Sally&quot;};

    public List&lt;Sample&gt; get() {
        int count = new Random().nextInt(10);
        return IntStream.range(0, count)
            .mapToObj(idx -&gt; Math.random() &gt; 0.5)
            .map(valid -&gt; new Sample(valid, names[(int)(Math.random() * names.length)], Math.random() + &quot;&quot;))
            .collect(Collectors.toList());
    }
}
</pre>

## Create Template

Let's make a directory to house our new template with this command:

`mkdir -p src/main/resources/templates/reports/v1`{{execute T2}}

Click `qute/src/main/resources/templates/reports/v1/report_01.json.template`{{open}} to open the new file.

Click **Copy to Editor** to create the template. We'll place it in the `src/main/resources/templates/reports/v1` path to simulate some sort of organization of different reports:

<pre class="file" data-filename="./qute/src/main/resources/templates/reports/v1/report_01.json.template" data-target="replace">
\{
    "time": "{now}",
    "samples": [
      {#for sample in samples}
      \{"name": "{sample.name ?: 'Unknown'}","data": "{#if sample.valid}{sample.data}{#else}--Invalid--{/if}"}{#if count < samples.size },{/if}
      {/for}
    ]
  }
</pre>

Here we are looping over the passed-in `samples`. You can iterate over `Iterable`s, `Map`s and `Stream`s. Since we are rendering JSON, we also need to escape the first of any pair of JSON-related `}` or `{` using `\}` or `\{`.

Also note the use of the [elvis operator](https://en.wikipedia.org/wiki/Elvis_operator) `{sample.name ?: 'Unknown'}` - if the name is `null` the default value `Unknown` is used.

## Create periodic reports

Create the ReportGenerator file by clicking `qute/src/main/java/org/acme/ReportGenerator.java`{{open}}.

And finally click **Copy to Editor** to add code that uses all of the above and generates reports periodically to a file in `/tmp`:

<pre class="file" data-filename="./qute/src/main/java/org/acme/ReportGenerator.java" data-target="replace">
package org.acme;

import java.io.FileWriter;

import javax.enterprise.context.ApplicationScoped;
import javax.enterprise.event.Observes;
import javax.inject.Inject;

import io.quarkus.qute.Template;
import io.quarkus.qute.Location;
import io.quarkus.runtime.ShutdownEvent;
import io.quarkus.runtime.StartupEvent;
import io.quarkus.scheduler.Scheduled;

@ApplicationScoped
public class ReportGenerator {

    @Inject
    SampleService service;

    private FileWriter fout = null;

    @Location("reports/v1/report_01.json.template")
    Template report;

    @Scheduled(cron="* * * ? * *")
    void generate() throws Exception {
        String result = report
            .data("samples", service.get())
            .data("now", java.time.LocalDateTime.now())
            .render();
            System.out.println("report: " + result);
        if (fout != null) {
            fout.write(result + "\n");
            fout.flush();
        }

    }

    void onStart(@Observes StartupEvent ev) throws Exception {
        fout = new FileWriter("/tmp/report.json", true);
    }
    void onShutdown(@Observes ShutdownEvent ev) throws Exception {
        fout.close();
        fout = null;
    }
}
</pre>

* In this case, we use the `@ResourcePath` qualifier to specify the template path: `templates/reports/v1/report_01.json`.
* Use the `@Scheduled` annotation to instruct Quarkus to execute this method every second. For more information see the [Scheduler](https://quarkus.io/guides/scheduler) guide.
* The `TemplateInstance.render()` method triggers rendering. Note that this method blocks the current thread.
* We use Quarkus' `StartupEvent` and `ShutdownEvent` to manage the File I/O on startup and shutdown

To trigger report to start generating (by triggering Quarkus Live Reload), click to run this command and access the `hello` endpoint:

`curl http://localhost:8080/hello?name=James`{{execute T2}}

Assuming no errors, our reports should generate every second. Let's `tail` the file:

`tail -f /tmp/report.json`{{execute T2}}

You should see new reports every second. When done, don't forget to type `CTRL-C` to stop the `tail -f`!
