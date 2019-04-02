## Data objects

The ``Portfolio`` object is a data object. Event bus proxies support a limited set of types, and for non-supported types, it must use data objects (please check the documentation for the whole list of supported types). Data objects are Java classes obeying to a set of constraints:

* It must be annotated with ``DataObject``

* It must have an empty constructor, a copy constructor and a constructor taking a ``JsonObject`` as parameter

* It must have a ``toJson`` method building a ``JsonObject`` representing the current object

* Fields must be property with (getters and setters)

Let's open the ``io.vertx.workshop.portfolio.Portfolio.java`` class to see what it looks like:

``portfolio-service/src/main/java/io/vertx/workshop/portfolio/Portfolio.java``{{open}}

As you can see, all the JSON handling is managed by ``converters`` that are automatically generated, so a data object is very close to a simple bean.