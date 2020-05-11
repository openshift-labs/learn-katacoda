This exercise demonstrated how Spring and Spring Boot developers can use well-known Spring annotations for Spring Data, Web, and Dependency Injection when building Quarkus applications. Spring developers can quickly become productive with Quarkus using existing knowledge and familiarity of these APIs.

You built a relatively simple application that uses Spring Data to integrate (via JPA) with an underlying database, inject beans using Spring DI and expose them as RESTful endpoints via Spring Rest.

> **NOTE**
> Please note that the Spring support in Quarkus does not start a Spring Application _Context_ nor are any Spring
> infrastructure classes run. Spring classes and annotations are only used for reading metadata and / or are used
> as user code method return types or parameter types. What that means for end users, is that adding arbitrary
> Spring to the classpath will not be used at all. Moreover Spring infrastructure things like
> `org.springframework.beans.factory.config.BeanPostProcessor` will not be run.

## Additional Resources

If you’re interested in helping continue to improve Quarkus, developing third-party extensions, using Quarkus to develop applications, or if you’re just curious about it, please check out these links:

* [Quarkus Website](http://quarkus.io/)
* [Red Hat Build of Quarkus](https://access.redhat.com/products/quarkus)
* [GitHub project](https://github.com/quarkusio/quarkus)
* [Twitter](https://twitter.com/QuarkusIO)
* [Chat](https://quarkusio.zulipchat.com/)
