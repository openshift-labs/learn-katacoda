In the previous step you added a CDI bean to your Kogito application. Now it's time to implement the process and use this bean from a _Service Task_.

## Open the BPMN2 process

Go back to the Kogito Online editor with the sample process we opened earlier, or re-open it by clicking on the following link: https://kiegroup.github.io/kogito-online/?file=https://raw.githubusercontent.com/kiegroup/kogito-runtimes/master/archetypes/kogito-quarkus-archetype/src/main/resources/archetype-resources/src/main/resources/test-process.bpmn2#/editor/bpmn2

## Change Process Name.

We will first change the _name_ and _id_ of the process. This, among other things, controls the name of the RESTful resource (URL) that will be generated for this process by Kogito.

In the BPMN editor, click on the pencil icon in the upper-right corner to open the properties panel.

![BPMN Editor Properties Panel](/openshift/assets/middleware/middleware-kogito/kogito-service-task-cdi-bpmn-editor-open-properties-panel.png)

Change the _Name_ and _ID_ of the process to `text_processor`.

![Process Name](/openshift/assets/middleware/middleware-kogito/kogito-service-task-cdi-process-name.png)

## Add Process Variable

Our application's functionality is to take an input `String` and convert it to uppercase. So, our process definition requires a process variable of type `String` to carry the data through the process.

Scroll down in the properties panel until you see the section _Process Data_. Expand this section and click on the _+_ sign to add a new process variable. Give the variable the name `mytext` and the type `String`. Leave the _KPI_ checkbox unchecked.

![Process Variable](/openshift/assets/middleware/middleware-kogito/kogito-service-task-cdi-process-variable.png)

## Create Service Task

In the diagram, double-click on the `Hello` _Script Task_ to change the name of the node. Change the name to `Process Text`.

![Process Text Node](/openshift/assets/middleware/middleware-kogito/kogito-service-task-cdi-process-text-node.png)

Next, we need to change the node from a _Script Task_ to a _Service Task_. To do this, click on the node, hoover over the gear icon in the lower-left corner of the node, and select _Convert into Service Task_ in the menu.

![Convert Into Service Task](/openshift/assets/middleware/middleware-kogito/kogito-service-task-cdi-convert-into-service-task.png)

## Configuring the Service Task

We can now configure the _Service Task_ so that it calls the `toUpper` method of our `TextProcessor` CDI bean, pass the `mytext` process variable to it, and map the result back. To do this, select the `Process Text` _Service Task_, and open the properties panel on the right side of the screen. Expand the _Implementation/Execution_ section. Set the following values:

* Implementation: `Java`
* Interface: `org.acme.TextProcessor`
* Operation: `toUpper`

![Service Task Implementation](/openshift/assets/middleware/middleware-kogito/kogito-service-task-cdi-service-task-implementation.png)

With the implementation configuration set, we can now configure the data _Assignments_. In the properties panel, click on the pencil icon in the _Assignments_ section. In the form that opens, add the following _input_ and _output_ data assignments.

![Service Task Data Assignment](/openshift/assets/middleware/middleware-kogito/kogito-service-task-cdi-service-task-data-assignment.png)

Note that the _Name_ of the input assignment is the name of the `toUpper` method argument in our `TextProcessor` CDI bean.

We have now implemented our process definition. It's time to copy it to our project. Click on the _File Actions_ button in the top-right corner of the BPMN editor. In the drop-down menu, click on _Copy source_. This will copy the source of your BPMN diagram to your clipboard.

Open the `test-process.bpmn2` file by clicking: `service-task-cdi/src/main/resources/test-process.bpmn2`{{open}}

Clear the file's content, and paste the BPMN2 definition that's in your clipboard to the file (right-click and select "Paste", or use Ctrl+V or Command+V, depending on your operating system).

## Test the process

Because we're using the hot-reload functionality of Kogito and Quarkus, we don't need to recompile and restart our application after we've implemented our functionality. We can simply send a new request, and the application will hot/live reload and serve the request. With the following request, we send the text `hello` to our process:

`curl -X POST "http://localhost:8080/text_processor" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"mytext\": \"hello\"}"`{{execute T2}}

As we can see from the response, the text is converted to uppercase.

## Congratulations!

In this scenario you've implemented the logic of a BPMN _Service Task_ node using CDI. There is much more to Kogito than CDI and hot-reload, so keep on exploring additional scenarios to learn more, and be sure to visit [kogito.kie.org](https://kogito.kie.org) to learn even more about the architecture and capabilities of this exciting new framework for Cloud Native Business Automation.
