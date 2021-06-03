**Background**

To help illustrate the most common features of Jakarta EE 8, you will build a web application called "Weather App". The application allows users to see weather information in the largest cities per country.

![The Weather App](../../assets/middleware/middleware-javaee8/weather-app.png)

A user can switch country by clicking on one of the flags in the menu.

![The Weather App](../../assets/middleware/middleware-javaee8/flags.png)

To save time there is a skeleton project with a prototype version that returns a hard-coded list of cities. What you will achieve are:

1.  Deploy the prototype to OpenShift
2. Read the weather information from a database (internal at first)
3. Allow the user to choose a country
4. Connect the application to an external database with weather information

### Review the current state of the prototype app

**Front-end**
The web application is a single page `./src/main/webapp/index.html`{{open}}.  In short, the front-end uses Bootstrap and jQuery. It uses REST to contact the back-end.

**Domain model**
Two Java classes represent the domain model for our application, `src/main/java/com/redhat/example/weather/Country.java`{{open}} and `src/main/java/com/redhat/example/weather/City.java`{{open}}.

![The Weather App](../../assets/middleware/middleware-javaee8/domain-model.png)

**REST application using JAX-RS**
The prototype already implements a simple REST based service to allow the front-end to retrieve a country object with a list of cities to display. To enable JAX-RS it's required to provide a class that extends the `javax.ws.rs.core.Application`  and configure the base URI (path) that is used to expose services. In the prototype, this is done in the `src/main/java/com/redhat/example/weather/RestApplication.java`{{open}}. In that class, we set the base URI to `/api`, which means that any call to the back-end using that URI is routed to the JAX-RS subsystem.

**Weather REST Service**
The current weather service `src/main/java/com/redhat/example/weather/WeatherService.java`{{open}} already implement a simple REST service using JAX-RS and returns a List with one country that is currently hard-coded. We will change that later in this service.

**User state**
Finally, for convenience, the prototype also includes `src/main/java/com/redhat/example/weather/SelectedCountry.java`{{open}} . This class is not in use at the moment, but we will make use of it later. The class is annotated with `@SessionScope` which tells the application server that the state of this class should be stored in the session scope. E.g., the state is maintained between different requests from the front-end to the back-end. However, if the user closes the browser or is inactive for too long, the state is removed. Using the session is a convenient way to store temporary state for a user that is ephemeral. For a persistent state, a database is typically used.

**Build configuration**
The prototype also includes build configuration in the `pom.xml`{{open}}. The build configuration is pretty simple but does include the `wildfly-maven-plugin`. Since we will be deploying to OpenShift, we will not use that plugin, but it's included here if you would like to use this project as a base for local development.

### Summary
If you are new to Jakarta EE development, the prototype might seem to include a lot "magic", but most of the code in here is normal Java and should be familiar if you have developed Java applications before. The reason we are providing this prototype is to be able to focus on Jakarta EE as quickly as possible and not spend time with setup.

The code for the prototype is available [here](https://github.com/openshift-katacoda/rhoar-getting-started/tree/master/javaee/weather-app) and the `solution` branch contains the finished application.
