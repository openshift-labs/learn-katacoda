



package com.redhat.service;

import java.util.Collection;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;

import com.redhat.coffeeservice.client.CoffeeResource;
import com.redhat.model.Coffee;

import org.apache.camel.CamelContext;
import org.apache.camel.Exchange;
import org.apache.camel.ExchangePattern;
import org.apache.camel.ProducerTemplate;
import org.apache.camel.builder.ExchangeBuilder;
import org.eclipse.microprofile.rest.client.inject.RestClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@ApplicationScoped
public class CoffeeService {

    private static final Logger LOGGER = LoggerFactory.getLogger(CoffeeService.class);

    @Inject
    @RestClient
    CoffeeResource coffeeResource;

    //Doesn't seem to work in Quarkus
    //@EndpointInject("direct://getCoffees")
    //private ProducerTemplate producer;

    @Inject
    CamelContext camelContext;

    private ProducerTemplate producer;

    @PostConstruct
    void init() {
        producer = camelContext.createProducerTemplate();
    }

    @PreDestroy
    void destroy() {
        producer.stop();
    }

    public Collection<Coffee> getCoffees() {
        LOGGER.debug("Retrieving coffees")
        Exchange requestExchange = ExchangeBuilder.anExchange(camelContext).withPattern(ExchangePattern.InOut).build();
        Exchange response = producer.send("direct://getCoffees", requestExchange);
        return (Collection<Coffee>) response.getMessage().getBody();
    }

}

## Congratulations!

You've now built a Kogito application as an executable JAR and a Linux native binary. Now let's give our app superpowers by deploying to OpenShift as a Linux container image.
