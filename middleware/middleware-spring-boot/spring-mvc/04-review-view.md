# Review the Home View

There are a number of View libraries supported by Spring MVC. One that has gained a lot of popularity and support is [Thymeleaf](https://www.thymeleaf.org/). Thymeleaf is often considered a HTML extension as Thymeleaf views are HTML with a couple of Thymeleaf attributes added. The benefit of this over something like JSPs is that Thymeleaf views still open in Web Browsers without the need for a running server. While this won't be a full in-depth overview of Thymeleaf we will cover some of the basics.

For our application we will use Thymeleaf. We already added the Spring Boot Starter POM for Thymeleaf in the first step. Spring Boot has a convention for Thymeleaf views: if a Thymeleaf View resides in the `src/main/resources/templates` folder it will automatically register that View for us. We have added the Home view for you so let's open that view: `src/main/resources/templates/home.html`{{open}}

The first thing to notice in this file is the `<html xmlns:th="http://www.thymeleaf.org">` tag. The `xmlns:th` describes the Thymeleaf namespace and assigns it to the `th` prefix. This gives us access to the Thymeleaf tag attributes.

We then skip down to the Form: `<form th:action="@{/api/fruits}" th:object="${fruitForm}" method="post">`. As you can see this is a standard HTML `<form>` with two Thymeleaf attributes added.

`th:action` is our first Thymeleaf attribute. Using this attribute with what is known as a [Link Expression](https://www.thymeleaf.org/doc/articles/standarddialect5minutes.html#link-url-expressions) (the `@{/api/fruits}` bit) we can create a context-independent link between our Form and the backend application.

`th:object` is our second Thymeleaf tag. This tag binds the form to a Model attribute called `fruitForm`. As a refresher from the Model/Controller section: 

```java
model.addAttribute("fruitForm", new Fruit()); // For the Form
```

This binding binds our Form fields to the `Fruit` object we assigned to the `fruitForm` Model attribute. When we submit the Form the name field gets bound to a Fruit object and sent to our Controller. 

The last set of attributes are for the Fruits List:

```
<div class="row" th:each="fruit : ${fruits}">
    <div class="col-2" th:text="${fruit.name}"></div>
</div>
```

For multiple entries coming from the application Thymeleaf provides a `th:each` attribute which allows us to iterate through a Collection and create elements for each iteration. In this case we are adding a `<div/>` element for each Fruit object in the `fruits` List. The `th:text` attribute replaces the text content of the tag with the `name` field of our `Fruit` object.

## Congratulations

Now you've seen how to get started with Thymeleaf as a View library for a Spring MVC application. There are so many other concepts to explore with Thymeleaf and we've only scratched the surface here. 