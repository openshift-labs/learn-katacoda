# Spring DI in Quarkus

While you are encouraged to use CDI annotations for injection, Quarkus provides a compatibility layer for Spring dependency injection in the form of the `spring-di` extension.

This step explains how your Quarkus application can leverage the well known Dependency Injection annotations included in the Spring Framework.

Let’s proceed to create some beans using various Spring annotations.

## Create Functional Interface

First we will create a `StringFunction` interface that some our beans will implement and which will be injected into another bean later on. This _Functional Interface_ provide target types for lambda expressions and method references we'll define.

> Functional Interfaces are part of the base Java platform, and are not Spring-specific.

Click here to create and open a new file for our interface: `fruit-taster/src/main/java/org/acme/StringFunction.java`{{open}}.

Click **Copy to Editor** to create the code for the interface:

<pre class="file" data-filename="./fruit-taster/src/main/java/org/acme/StringFunction.java" data-target="replace">
package org.acme;

import java.util.function.Function;

public interface StringFunction extends Function&lt;String, String&gt; {

}
</pre>

With the interface in place, we will add an `AppConfiguration` class which will use the Spring’s Java Config style for defining a bean. It will be used to create a `StringFunction` bean that will capitalize the text passed as parameter.

Click here to create and open a new file for our configuration: `fruit-taster/src/main/java/org/acme/AppConfiguration.java`{{open}}.

Click **Copy to Editor** to create the code for the interface:

<pre class="file" data-filename="./fruit-taster/src/main/java/org/acme/AppConfiguration.java" data-target="replace">
package org.acme;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfiguration {

    @Bean(name = "capitalizeFunction")
    public StringFunction capitalizer() {
        return String::toUpperCase;
    }
}
</pre>

## Create Functions

Now we define another bean that will implement `StringFunction` using Spring’s _stereotype annotation_ style. This bean will effectively be a no-op bean that simply returns the input as is.

Click here to create and open a new file for our bean: `fruit-taster/src/main/java/org/acme/NoOpSingleStringFunction.java`{{open}}.

Click **Copy to Editor** to create the code for the interface:

<pre class="file" data-filename="./fruit-taster/src/main/java/org/acme/NoOpSingleStringFunction.java" data-target="replace">
package org.acme;

import org.springframework.stereotype.Component;

@Component("noopFunction")
public class NoOpSingleStringFunction implements StringFunction {

    @Override
    public String apply(String s) {
        return s;
    }
}
</pre>

## Add injectable configuration

Quarkus also provides support for injecting configuration values using Spring’s `@Value` annotation. To see that in action, click **Copy to Editor** to add a new configuration parameter to our application which we'll use to add a little flavor to our app:

<pre class="file" data-filename="./fruit-taster/src/main/resources/application.properties" data-target="append">
taste.message = tastes great
</pre>

We'll also need a new Spring Bean to use this configuration! Click here to create and open a new file for our configuration: `fruit-taster/src/main/java/org/acme/MessageProducer.java`{{open}}.

Click **Copy to Editor** to create the code for the interface:

<pre class="file" data-filename="./fruit-taster/src/main/java/org/acme/MessageProducer.java" data-target="replace">
package org.acme;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class MessageProducer {

    @Value("${taste.message}")
    String message;

    public String getTaste() {
        return message;
    }
}
</pre>

## Tie them all together

The final bean we will create ties together all the previous beans.

Click here to create and open a new file for our configuration: `fruit-taster/src/main/java/org/acme/TasterBean.java`{{open}}.

Click **Copy to Editor** to create the code for the bean:

<pre class="file" data-filename="./fruit-taster/src/main/java/org/acme/TasterBean.java" data-target="replace">
package org.acme;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class TasterBean {

    private final MessageProducer messageProducer;

    @Autowired
    @Qualifier("noopFunction")
    StringFunction noopStringFunction;

    @Autowired
    @Qualifier("capitalizeFunction")
    StringFunction capitalizerStringFunction;

    @Value("${taste.suffix:!}")
    String suffix;

    public TasterBean(MessageProducer messageProducer) {
        this.messageProducer = messageProducer;
    }

    public String taste(String fruitName) {
        final String initialValue = fruitName + ": " + messageProducer.getTaste() + " " + suffix;
        return noopStringFunction.andThen(capitalizerStringFunction).apply(initialValue);
    }
}
</pre>

In the code above, we see that both field injection and constructor injection are being used (note that constructor injection does not need the `@Autowired` annotation since there is a single constructor). Furthermore, the `@Value` annotation on `suffix` has also a default value defined, which in this case will be used since we have not defined `taste.suffix` in `application.properties`.

This new `TasterBean` has a method `taste()` which will report how each fruit tastes. It also uses our functions `noopStringFunction` and `capitalizerStringFunction` that we've injected via `@Autowired` to both do nothing and also transform the result INTO ALL CAPS.

With our data model, repository, and accessor beans in place, let's move to the final step where we'll expose our fruits to the outside world via Spring Web annotations.
