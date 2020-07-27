This exercise demonstrates how your Quarkus application can utilize the [Qute Templating Engine](https://quarkus.io/guides/qute) feature to build type-safe, server-side templates which can be rendered at will in Quarkus applications.

![Logo](/openshift/assets/middleware/quarkus/logo.png)

Qute is a templating engine designed specifically to meet Quarkus' needs. The usage of reflection is minimized to reduce the size of native images. The API combines both the imperative and the non-blocking reactive style of coding. In the development mode, all files located in `src/main/resources/templates` are watched for changes and modifications are immediately visible. Furthermore, we try to detect most of the template problems at build time. In this exercise, you will learn how to easily render templates in your application.

The **Qute** engine renders templates (ordinary files with things like `Hello {name}!`). The expression `{name}` embedded in the template is replaced with the value of the corresponding value passed in as context (a simple string, or perhaps a `Map` of key/value pairs). Due to its type-safe goals, the engine will attempt to validate expressions during the build, to catch any errors or typos or other mismatched expressions.

> Qute is currently an experimental feature in Quarkus. There is no guarantee of stability nor long term presence in the platform until the solution matures.
>
> An [introduction guide](https://quarkus.io/guides/qute) and a more comprehensive [reference guide](https://quarkus.io/guides/qute-reference) are available.

Let's get going!
