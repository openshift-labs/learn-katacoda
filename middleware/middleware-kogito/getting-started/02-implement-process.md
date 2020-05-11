In the previous step you've created a skeleton Kogito application with Quarkus. In this step we'll create our first process definition in BPMN2. We will see how Kogito is able to generate a microservice, including RESTful resources, from our business assets (e.g. process definitions, decisions, etc.).

## Create a process definition

Let’s modify the application and add a process definition.

We will create a simple process that will look like this:

![Process](/openshift/assets/middleware/middleware-kogito/kogito-getting-started-process.png)

Open a new BPMN2 file by clicking: `getting-started/src/main/resources/getting-started.bpmn`{{open}}

BPMN2 allows us to define a graphical representation of a process (or workflow), and as such, we need a BPMN2 editor to implement our process. Kogito provides an online BPMN2 editor that we can use to build our process.

Click on the "Kogito BPMN Tooling" tab next to the "OpenShift Console" tab to open the Kogito BPMN Tooling, or navigate to: https://bpmn.new

Implement the process as shown in the following video. Make sure to use `getting_started` for the **name** and **id** of the process and `org.acme` for the **package**.

https://youtu.be/babjHSNrZBg

After you've defined your process, click on the **File Actions -> Copy source** button to copy the BPMN2 XML definition to your clipboard.

Copy the content of your clipboard to the `getting-started/src/main/resources/getting-started.bpmn` file you've created and opened earlier using `Ctrl+v ` or `Command-v` (depending on your type of computer).

Alternatively, you can copy the following BPMN2 definition to the BPMN file:

<pre class="file" data-filename="./getting-started/src/main/resources/getting-started.bpmn" data-target="replace">
&lt;bpmn2:definitions xmlns:xsi=&quot;http://www.w3.org/2001/XMLSchema-instance&quot; xmlns:bpmn2=&quot;http://www.omg.org/spec/BPMN/20100524/MODEL&quot; xmlns:bpmndi=&quot;http://www.omg.org/spec/BPMN/20100524/DI&quot; xmlns:bpsim=&quot;http://www.bpsim.org/schemas/1.0&quot; xmlns:dc=&quot;http://www.omg.org/spec/DD/20100524/DC&quot; xmlns:di=&quot;http://www.omg.org/spec/DD/20100524/DI&quot; xmlns:drools=&quot;http://www.jboss.org/drools&quot; id=&quot;_3B7B4D14-4B20-497A-868A-D7B55CD93887&quot; exporter=&quot;jBPM Process Modeler&quot; exporterVersion=&quot;2.0&quot; targetNamespace=&quot;http://www.omg.org/bpmn20&quot;&gt;
  &lt;bpmn2:itemDefinition id=&quot;__8C980097-4DBD-4BAF-B991-73EC1419E8CE_SkippableInputXItem&quot; structureRef=&quot;Object&quot;/&gt;
  &lt;bpmn2:itemDefinition id=&quot;__8C980097-4DBD-4BAF-B991-73EC1419E8CE_PriorityInputXItem&quot; structureRef=&quot;Object&quot;/&gt;
  &lt;bpmn2:itemDefinition id=&quot;__8C980097-4DBD-4BAF-B991-73EC1419E8CE_CommentInputXItem&quot; structureRef=&quot;Object&quot;/&gt;
  &lt;bpmn2:itemDefinition id=&quot;__8C980097-4DBD-4BAF-B991-73EC1419E8CE_DescriptionInputXItem&quot; structureRef=&quot;Object&quot;/&gt;
  &lt;bpmn2:itemDefinition id=&quot;__8C980097-4DBD-4BAF-B991-73EC1419E8CE_CreatedByInputXItem&quot; structureRef=&quot;Object&quot;/&gt;
  &lt;bpmn2:itemDefinition id=&quot;__8C980097-4DBD-4BAF-B991-73EC1419E8CE_TaskNameInputXItem&quot; structureRef=&quot;Object&quot;/&gt;
  &lt;bpmn2:itemDefinition id=&quot;__8C980097-4DBD-4BAF-B991-73EC1419E8CE_GroupIdInputXItem&quot; structureRef=&quot;Object&quot;/&gt;
  &lt;bpmn2:itemDefinition id=&quot;__8C980097-4DBD-4BAF-B991-73EC1419E8CE_ContentInputXItem&quot; structureRef=&quot;Object&quot;/&gt;
  &lt;bpmn2:itemDefinition id=&quot;__8C980097-4DBD-4BAF-B991-73EC1419E8CE_NotStartedReassignInputXItem&quot; structureRef=&quot;Object&quot;/&gt;
  &lt;bpmn2:itemDefinition id=&quot;__8C980097-4DBD-4BAF-B991-73EC1419E8CE_NotCompletedReassignInputXItem&quot; structureRef=&quot;Object&quot;/&gt;
  &lt;bpmn2:itemDefinition id=&quot;__8C980097-4DBD-4BAF-B991-73EC1419E8CE_NotStartedNotifyInputXItem&quot; structureRef=&quot;Object&quot;/&gt;
  &lt;bpmn2:itemDefinition id=&quot;__8C980097-4DBD-4BAF-B991-73EC1419E8CE_NotCompletedNotifyInputXItem&quot; structureRef=&quot;Object&quot;/&gt;
  &lt;bpmn2:process id=&quot;getting_started&quot; drools:packageName=&quot;org.acme&quot; drools:version=&quot;1.0&quot; drools:adHoc=&quot;false&quot; name=&quot;getting_started&quot; isExecutable=&quot;true&quot; processType=&quot;Public&quot;&gt;
    &lt;bpmn2:sequenceFlow id=&quot;_3B95A0A8-3313-487C-A14E-972E04D228B5&quot; sourceRef=&quot;_8C980097-4DBD-4BAF-B991-73EC1419E8CE&quot; targetRef=&quot;_3F791B0E-1549-441F-AA55-B70154E227B2&quot;&gt;
      &lt;bpmn2:extensionElements&gt;
        &lt;drools:metaData name=&quot;isAutoConnection.source&quot;&gt;
          &lt;drools:metaValue&gt;true&lt;/drools:metaValue&gt;
        &lt;/drools:metaData&gt;
        &lt;drools:metaData name=&quot;isAutoConnection.target&quot;&gt;
          &lt;drools:metaValue&gt;true&lt;/drools:metaValue&gt;
        &lt;/drools:metaData&gt;
      &lt;/bpmn2:extensionElements&gt;
    &lt;/bpmn2:sequenceFlow&gt;
    &lt;bpmn2:sequenceFlow id=&quot;_D96968A8-096F-441E-BEF5-69B5EB7B1C91&quot; sourceRef=&quot;_3872BDA1-71C9-49B4-B15F-9800547FEA0A&quot; targetRef=&quot;_8C980097-4DBD-4BAF-B991-73EC1419E8CE&quot;&gt;
      &lt;bpmn2:extensionElements&gt;
        &lt;drools:metaData name=&quot;isAutoConnection.source&quot;&gt;
          &lt;drools:metaValue&gt;true&lt;/drools:metaValue&gt;
        &lt;/drools:metaData&gt;
        &lt;drools:metaData name=&quot;isAutoConnection.target&quot;&gt;
          &lt;drools:metaValue&gt;true&lt;/drools:metaValue&gt;
        &lt;/drools:metaData&gt;
      &lt;/bpmn2:extensionElements&gt;
    &lt;/bpmn2:sequenceFlow&gt;
    &lt;bpmn2:endEvent id=&quot;_3F791B0E-1549-441F-AA55-B70154E227B2&quot;&gt;
      &lt;bpmn2:incoming&gt;_3B95A0A8-3313-487C-A14E-972E04D228B5&lt;/bpmn2:incoming&gt;
    &lt;/bpmn2:endEvent&gt;
    &lt;bpmn2:userTask id=&quot;_8C980097-4DBD-4BAF-B991-73EC1419E8CE&quot; name=&quot;Task&quot;&gt;
      &lt;bpmn2:extensionElements&gt;
        &lt;drools:metaData name=&quot;elementname&quot;&gt;
          &lt;drools:metaValue&gt;Task&lt;/drools:metaValue&gt;
        &lt;/drools:metaData&gt;
      &lt;/bpmn2:extensionElements&gt;
      &lt;bpmn2:incoming&gt;_D96968A8-096F-441E-BEF5-69B5EB7B1C91&lt;/bpmn2:incoming&gt;
      &lt;bpmn2:outgoing&gt;_3B95A0A8-3313-487C-A14E-972E04D228B5&lt;/bpmn2:outgoing&gt;
      &lt;bpmn2:ioSpecification id=&quot;_FdyD4AJMEDiMpvp3hRnB7A&quot;&gt;
        &lt;bpmn2:dataInput id=&quot;_8C980097-4DBD-4BAF-B991-73EC1419E8CE_TaskNameInputX&quot; drools:dtype=&quot;Object&quot; itemSubjectRef=&quot;__8C980097-4DBD-4BAF-B991-73EC1419E8CE_TaskNameInputXItem&quot; name=&quot;TaskName&quot;/&gt;
        &lt;bpmn2:dataInput id=&quot;_8C980097-4DBD-4BAF-B991-73EC1419E8CE_SkippableInputX&quot; drools:dtype=&quot;Object&quot; itemSubjectRef=&quot;__8C980097-4DBD-4BAF-B991-73EC1419E8CE_SkippableInputXItem&quot; name=&quot;Skippable&quot;/&gt;
        &lt;bpmn2:inputSet id=&quot;_Fdyq8AJMEDiMpvp3hRnB7A&quot;&gt;
          &lt;bpmn2:dataInputRefs&gt;_8C980097-4DBD-4BAF-B991-73EC1419E8CE_TaskNameInputX&lt;/bpmn2:dataInputRefs&gt;
          &lt;bpmn2:dataInputRefs&gt;_8C980097-4DBD-4BAF-B991-73EC1419E8CE_SkippableInputX&lt;/bpmn2:dataInputRefs&gt;
        &lt;/bpmn2:inputSet&gt;
      &lt;/bpmn2:ioSpecification&gt;
      &lt;bpmn2:dataInputAssociation id=&quot;_Fdyq8QJMEDiMpvp3hRnB7A&quot;&gt;
        &lt;bpmn2:targetRef&gt;_8C980097-4DBD-4BAF-B991-73EC1419E8CE_TaskNameInputX&lt;/bpmn2:targetRef&gt;
        &lt;bpmn2:assignment id=&quot;_Fdyq8gJMEDiMpvp3hRnB7A&quot;&gt;
          &lt;bpmn2:from xsi:type=&quot;bpmn2:tFormalExpression&quot; id=&quot;_Fdz5EAJMEDiMpvp3hRnB7A&quot;&gt;Task&lt;/bpmn2:from&gt;
          &lt;bpmn2:to xsi:type=&quot;bpmn2:tFormalExpression&quot; id=&quot;_Fd0gIAJMEDiMpvp3hRnB7A&quot;&gt;_8C980097-4DBD-4BAF-B991-73EC1419E8CE_TaskNameInputX&lt;/bpmn2:to&gt;
        &lt;/bpmn2:assignment&gt;
      &lt;/bpmn2:dataInputAssociation&gt;
      &lt;bpmn2:dataInputAssociation id=&quot;_Fd0gIQJMEDiMpvp3hRnB7A&quot;&gt;
        &lt;bpmn2:targetRef&gt;_8C980097-4DBD-4BAF-B991-73EC1419E8CE_SkippableInputX&lt;/bpmn2:targetRef&gt;
        &lt;bpmn2:assignment id=&quot;_Fd0gIgJMEDiMpvp3hRnB7A&quot;&gt;
          &lt;bpmn2:from xsi:type=&quot;bpmn2:tFormalExpression&quot; id=&quot;_Fd1HMAJMEDiMpvp3hRnB7A&quot;&gt;false&lt;/bpmn2:from&gt;
          &lt;bpmn2:to xsi:type=&quot;bpmn2:tFormalExpression&quot; id=&quot;_Fd1HMQJMEDiMpvp3hRnB7A&quot;&gt;_8C980097-4DBD-4BAF-B991-73EC1419E8CE_SkippableInputX&lt;/bpmn2:to&gt;
        &lt;/bpmn2:assignment&gt;
      &lt;/bpmn2:dataInputAssociation&gt;
    &lt;/bpmn2:userTask&gt;
    &lt;bpmn2:startEvent id=&quot;_3872BDA1-71C9-49B4-B15F-9800547FEA0A&quot;&gt;
      &lt;bpmn2:outgoing&gt;_D96968A8-096F-441E-BEF5-69B5EB7B1C91&lt;/bpmn2:outgoing&gt;
    &lt;/bpmn2:startEvent&gt;
  &lt;/bpmn2:process&gt;
  &lt;bpmndi:BPMNDiagram&gt;
    &lt;bpmndi:BPMNPlane bpmnElement=&quot;getting_started&quot;&gt;
      &lt;bpmndi:BPMNShape id=&quot;shape__3872BDA1-71C9-49B4-B15F-9800547FEA0A&quot; bpmnElement=&quot;_3872BDA1-71C9-49B4-B15F-9800547FEA0A&quot;&gt;
        &lt;dc:Bounds height=&quot;56&quot; width=&quot;56&quot; x=&quot;176&quot; y=&quot;319&quot;/&gt;
      &lt;/bpmndi:BPMNShape&gt;
      &lt;bpmndi:BPMNShape id=&quot;shape__8C980097-4DBD-4BAF-B991-73EC1419E8CE&quot; bpmnElement=&quot;_8C980097-4DBD-4BAF-B991-73EC1419E8CE&quot;&gt;
        &lt;dc:Bounds height=&quot;102&quot; width=&quot;154&quot; x=&quot;331&quot; y=&quot;296&quot;/&gt;
      &lt;/bpmndi:BPMNShape&gt;
      &lt;bpmndi:BPMNShape id=&quot;shape__3F791B0E-1549-441F-AA55-B70154E227B2&quot; bpmnElement=&quot;_3F791B0E-1549-441F-AA55-B70154E227B2&quot;&gt;
        &lt;dc:Bounds height=&quot;56&quot; width=&quot;56&quot; x=&quot;617&quot; y=&quot;319&quot;/&gt;
      &lt;/bpmndi:BPMNShape&gt;
      &lt;bpmndi:BPMNEdge id=&quot;edge_shape__3872BDA1-71C9-49B4-B15F-9800547FEA0A_to_shape__8C980097-4DBD-4BAF-B991-73EC1419E8CE&quot; bpmnElement=&quot;_D96968A8-096F-441E-BEF5-69B5EB7B1C91&quot;&gt;
        &lt;di:waypoint x=&quot;232&quot; y=&quot;347&quot;/&gt;
        &lt;di:waypoint x=&quot;331&quot; y=&quot;347&quot;/&gt;
      &lt;/bpmndi:BPMNEdge&gt;
      &lt;bpmndi:BPMNEdge id=&quot;edge_shape__8C980097-4DBD-4BAF-B991-73EC1419E8CE_to_shape__3F791B0E-1549-441F-AA55-B70154E227B2&quot; bpmnElement=&quot;_3B95A0A8-3313-487C-A14E-972E04D228B5&quot;&gt;
        &lt;di:waypoint x=&quot;485&quot; y=&quot;347&quot;/&gt;
        &lt;di:waypoint x=&quot;617&quot; y=&quot;347&quot;/&gt;
      &lt;/bpmndi:BPMNEdge&gt;
    &lt;/bpmndi:BPMNPlane&gt;
  &lt;/bpmndi:BPMNDiagram&gt;
  &lt;bpmn2:relationship id=&quot;_Fd2VUAJMEDiMpvp3hRnB7A&quot; type=&quot;BPSimData&quot;&gt;
    &lt;bpmn2:extensionElements&gt;
      &lt;bpsim:BPSimData&gt;
        &lt;bpsim:Scenario id=&quot;default&quot; name=&quot;Simulationscenario&quot;&gt;
          &lt;bpsim:ScenarioParameters/&gt;
          &lt;bpsim:ElementParameters elementRef=&quot;_3872BDA1-71C9-49B4-B15F-9800547FEA0A&quot;&gt;
            &lt;bpsim:TimeParameters&gt;
              &lt;bpsim:ProcessingTime&gt;
                &lt;bpsim:NormalDistribution mean=&quot;0&quot; standardDeviation=&quot;0&quot;/&gt;
              &lt;/bpsim:ProcessingTime&gt;
            &lt;/bpsim:TimeParameters&gt;
          &lt;/bpsim:ElementParameters&gt;
          &lt;bpsim:ElementParameters elementRef=&quot;_8C980097-4DBD-4BAF-B991-73EC1419E8CE&quot;&gt;
            &lt;bpsim:TimeParameters&gt;
              &lt;bpsim:ProcessingTime&gt;
                &lt;bpsim:NormalDistribution mean=&quot;0&quot; standardDeviation=&quot;0&quot;/&gt;
              &lt;/bpsim:ProcessingTime&gt;
            &lt;/bpsim:TimeParameters&gt;
            &lt;bpsim:ResourceParameters&gt;
              &lt;bpsim:Availability&gt;
                &lt;bpsim:FloatingParameter value=&quot;0&quot;/&gt;
              &lt;/bpsim:Availability&gt;
              &lt;bpsim:Quantity&gt;
                &lt;bpsim:FloatingParameter value=&quot;0&quot;/&gt;
              &lt;/bpsim:Quantity&gt;
            &lt;/bpsim:ResourceParameters&gt;
            &lt;bpsim:CostParameters&gt;
              &lt;bpsim:UnitCost&gt;
                &lt;bpsim:FloatingParameter value=&quot;0&quot;/&gt;
              &lt;/bpsim:UnitCost&gt;
            &lt;/bpsim:CostParameters&gt;
          &lt;/bpsim:ElementParameters&gt;
        &lt;/bpsim:Scenario&gt;
      &lt;/bpsim:BPSimData&gt;
    &lt;/bpmn2:extensionElements&gt;
    &lt;bpmn2:source&gt;_3B7B4D14-4B20-497A-868A-D7B55CD93887&lt;/bpmn2:source&gt;
    &lt;bpmn2:target&gt;_3B7B4D14-4B20-497A-868A-D7B55CD93887&lt;/bpmn2:target&gt;
  &lt;/bpmn2:relationship&gt;
&lt;/bpmn2:definitions&gt;
</pre>

Since we still have our app running using `mvn quarkus:dev`, when you make these changes and reload the endpoint, Quarkus will notice all of these changes and live-reload them, including changes in your business assets (i.e. processes, decision, rules, etc.).

Check that it works as expected by opening the Swagger-UI endpoint by [clicking here](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui). The Swagger-UI will show the REST resources that have been generated from the project's _business assets_, in this case the `getting_started` resource, which is backed by our process definition (note that the sample _Greetings_ resource is also still shown in the Swagger UI).

In the Swagger UI, expand the **POST /getting_started** resource. Click on the **Try it out** button on the right-hand-side of the screen. Click on the blue **Execute** button to fire the request. The response will be the instance-id/process-id of the created **getting_started** resource.

![Swagger](/openshift/assets/middleware/middleware-kogito/kogito-getting-started-swagger.png)

Apart from the Swagger-UI, we can also call our RESTful resources from any REST client, for example via **cURL** in a terminal.

Because the original Terminal tab already has our application running, we need to run this command in a second Terminal tab. Click on the following command to run it in your other Terminal tab. This will return the list of **getting_started** resource instances, which currently contains the single instance we created earlier:

`curl -X GET "http://localhost:8080/getting_started" -H "accept: application/json"`{{execute T2}}

> You can also open additional terminals with the "+" button on the tab bar to the right.
> ![Open Terminal](/openshift/assets/middleware/middleware-kogito/katacoda-open-new-terminal.png)

Our process defintion contains a *UserTask*. To retrieve the tasks of an instance, we need to execute another REST operation.

Let's go back to the [Swagger-UI](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui). Expand the **GET ​/getting_started​/{id}​/tasks** operation, and click on the **Try it out** button. In the `id` field, fill in the value of the process instance id the previous command returned. Now, click on the **Execute** button.

This will return a list of **Tasks**.

![Tasks](/openshift/assets/middleware/middleware-kogito/kogito-getting-started-get-tasks.png)

Since we haven't defined any Task input and output data yet, we can simply complete the task without providing any data. We will again do this from the [Swagger-UI](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui). Expand the **POST ​/getting_started​/{id}​/Task/{workitemId}** operation, and click on the **Try it out** button. In the `id` field, fill in the value of the process instance id, and fill in the task-id that we retrieved with our previous REST call in the `workItemId` field. Now, click on the **Execute** button.

This will complete the task, and the process will continue and reach the *End* node and complete.

![Complete Tasks](/openshift/assets/middleware/middleware-kogito/kogito-getting-started-complete-task.png)

With the task completed, the process instance will now be completed. Execute the following command again in the Terminal by clicking on it. Notice that there are no process instances returned:

`curl -X GET "http://localhost:8080/getting_started" -H "accept: application/json"`{{execute T2}}

## Congratulations!

You've created your first Kogito application. You've defined a process in BPMN2, have seen the **live-reload** in action. You've experienced how Kogito automatically generates REST resources based on your process definition. Finally, you've started a process instance, retrieved the task list, completed a task and thereby finished the process instance.
