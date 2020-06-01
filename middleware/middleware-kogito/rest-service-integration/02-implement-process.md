In the previous step we've created a skeleton Kogito application with Quarkus. In this step we'll create the initial part of our _coffeeshop_ process. This will be a very simple process that only retrieves the available types of coffees from the _CoffeeMenuService_. This scenario is only intended to demonstrate the capabilities of Kogito. The rest of our _coffeeshop process_ would for example include a _UserTask_ to select the type of coffee, selection of a payment method, integration with an external payment provider, and an event to the barista to make the requested coffee.

## Create a process definition

Let’s modify the application and add our simple _coffeeshop process_.

We create a simple process that will look like this:

![Process](/openshift/assets/middleware/middleware-kogito/kogito-rest-coffeeshop-process.png)

Click the following path to open a new _coffeeshop process_ BPMN2 file: `coffeeshop/src/main/resources/coffeeshop-process.bpmn`{{open}}

BPMN2 allows us to define a graphical representation of a process (or workflow), and as such, we need a BPMN2 editor to implement our process. Kogito provides an online BPMN2 editor that we can use to build our process.

Click on the "Kogito BPMN Tooling" tab next to the "OpenShift Console" tab to open the Kogito BPMN Tooling, or navigate to: https://bpmn.new

Implement the process as follows (note that we can also bypass this step and simply copy the pre-made BPMN2 file provided below):

* Click the pencil icon on the right-hand-side of the screen to open the property panel. Set the following name, id and package:
** Name: `coffeeshop`
** ID: `coffeeshop`
** Package: `org.acme`
* Expand the _Process Data_ section and add the following _Process Variable_:
** Name: `coffees`
** Data Type: `java.util.Collection`
* Add the tag `output` to this variable. This controls, among other things, the generation of our RESTful API. I.e., a variable tagged with `output` will not be part of the input model, and thus does not need to be passed when starting a process. It is however part of the output model, and hence will be returned to the client as a response of the RESTful call.
* Create a StartEvent node.
* Create a Service Task node.
* Connect the Service Task node to the StartEvent.
* Give the Service Task node the name: "Get Coffee Menu"
* With the Service Task selected, open the property panel on the right-hand-side of the screen by clicking the pencil icon.
* Expand the _Implementation/Execution_ section. Set the following values:
** Implementation: `Java`
** Interface: `org.acme.service.CoffeeService`
** Operation: `getCoffees`
** Assignments: See image below

![GetCoffees Input Output](/openshift/assets/middleware/middleware-kogito/kogito-coffee-process-getcoffee-data-assignment.png)

* Create an EndEvent node and connect it to the Service Task node.

After we've defined our process, click on the **File Actions -> Copy source** button to copy the BPMN2 XML definition to our clipboard.

Copy the content of our clipboard to the `coffeeshop/src/main/resources/coffeeshop-process.bpmn` file we've created and opened earlier using `Ctrl+v ` or `Command-v` (depending on your type of computer).

Alternatively, we copy the following BPMN2 definition to the BPMN file:

<pre class="file" data-filename="./coffeeshop/src/main/resources/coffeeshop-process.bpmn" data-target="replace">
&lt;bpmn2:definitions xmlns:bpmn2=&quot;http://www.omg.org/spec/BPMN/20100524/MODEL&quot; xmlns:bpmndi=&quot;http://www.omg.org/spec/BPMN/20100524/DI&quot; xmlns:bpsim=&quot;http://www.bpsim.org/schemas/1.0&quot; xmlns:dc=&quot;http://www.omg.org/spec/DD/20100524/DC&quot; xmlns:di=&quot;http://www.omg.org/spec/DD/20100524/DI&quot; xmlns:drools=&quot;http://www.jboss.org/drools&quot; id=&quot;_F5Ou4HNMEDig17XG0NHLjQ&quot; exporter=&quot;jBPM Process Modeler&quot; exporterVersion=&quot;2.0&quot; targetNamespace=&quot;http://www.omg.org/bpmn20&quot;&gt;
  &lt;bpmn2:itemDefinition id=&quot;_coffeesItem&quot; structureRef=&quot;java.util.Collection&quot;/&gt;
  &lt;bpmn2:itemDefinition id=&quot;__3CDC6E61-DCC5-4831-8BBB-417CFF517CB0_coffeesOutputXItem&quot; structureRef=&quot;java.util.Collection&quot;/&gt;
  &lt;bpmn2:interface id=&quot;_3CDC6E61-DCC5-4831-8BBB-417CFF517CB0_ServiceInterface&quot; name=&quot;org.acme.service.CoffeeService&quot; implementationRef=&quot;org.acme.service.CoffeeService&quot;&gt;
    &lt;bpmn2:operation id=&quot;_3CDC6E61-DCC5-4831-8BBB-417CFF517CB0_ServiceOperation&quot; name=&quot;getCoffees&quot; implementationRef=&quot;getCoffees&quot;/&gt;
  &lt;/bpmn2:interface&gt;
  &lt;bpmn2:process id=&quot;coffeeshop&quot; drools:packageName=&quot;org.acme&quot; drools:version=&quot;1.0&quot; drools:adHoc=&quot;false&quot; name=&quot;coffeeshop&quot; isExecutable=&quot;true&quot; processType=&quot;Public&quot;&gt;
    &lt;bpmn2:property id=&quot;coffees&quot; itemSubjectRef=&quot;_coffeesItem&quot; name=&quot;coffees&quot;&gt;
      &lt;bpmn2:extensionElements&gt;
        &lt;drools:metaData name=&quot;customTags&quot;&gt;
          &lt;drools:metaValue&gt;&lt;![CDATA[output]]&gt;&lt;/drools:metaValue&gt;
        &lt;/drools:metaData&gt;
      &lt;/bpmn2:extensionElements&gt;
    &lt;/bpmn2:property&gt;
    &lt;bpmn2:sequenceFlow id=&quot;_323FD4C9-FC3D-404F-9156-E3F83B45A799&quot; sourceRef=&quot;_3CDC6E61-DCC5-4831-8BBB-417CFF517CB0&quot; targetRef=&quot;_D74E4311-5CAB-4CBE-9B83-C12961961633&quot;&gt;
      &lt;bpmn2:extensionElements&gt;
        &lt;drools:metaData name=&quot;isAutoConnection.source&quot;&gt;
          &lt;drools:metaValue&gt;&lt;![CDATA[true]]&gt;&lt;/drools:metaValue&gt;
        &lt;/drools:metaData&gt;
        &lt;drools:metaData name=&quot;isAutoConnection.target&quot;&gt;
          &lt;drools:metaValue&gt;&lt;![CDATA[true]]&gt;&lt;/drools:metaValue&gt;
        &lt;/drools:metaData&gt;
      &lt;/bpmn2:extensionElements&gt;
    &lt;/bpmn2:sequenceFlow&gt;
    &lt;bpmn2:sequenceFlow id=&quot;_00AB4A77-D70F-4086-8BA6-57DD017A5323&quot; sourceRef=&quot;_75AC8C0C-CFBD-4ADF-A3B4-83AB90581A73&quot; targetRef=&quot;_3CDC6E61-DCC5-4831-8BBB-417CFF517CB0&quot;&gt;
      &lt;bpmn2:extensionElements&gt;
        &lt;drools:metaData name=&quot;isAutoConnection.source&quot;&gt;
          &lt;drools:metaValue&gt;&lt;![CDATA[true]]&gt;&lt;/drools:metaValue&gt;
        &lt;/drools:metaData&gt;
        &lt;drools:metaData name=&quot;isAutoConnection.target&quot;&gt;
          &lt;drools:metaValue&gt;&lt;![CDATA[true]]&gt;&lt;/drools:metaValue&gt;
        &lt;/drools:metaData&gt;
      &lt;/bpmn2:extensionElements&gt;
    &lt;/bpmn2:sequenceFlow&gt;
    &lt;bpmn2:endEvent id=&quot;_D74E4311-5CAB-4CBE-9B83-C12961961633&quot;&gt;
      &lt;bpmn2:incoming&gt;_323FD4C9-FC3D-404F-9156-E3F83B45A799&lt;/bpmn2:incoming&gt;
    &lt;/bpmn2:endEvent&gt;
    &lt;bpmn2:serviceTask id=&quot;_3CDC6E61-DCC5-4831-8BBB-417CFF517CB0&quot; drools:serviceimplementation=&quot;Java&quot; drools:serviceinterface=&quot;org.acme.service.CoffeeService&quot; drools:serviceoperation=&quot;getCoffees&quot; name=&quot;Get Coffee Menu&quot; implementation=&quot;Java&quot; operationRef=&quot;_3CDC6E61-DCC5-4831-8BBB-417CFF517CB0_ServiceOperation&quot;&gt;
      &lt;bpmn2:extensionElements&gt;
        &lt;drools:metaData name=&quot;elementname&quot;&gt;
          &lt;drools:metaValue&gt;&lt;![CDATA[Get Coffee Menu]]&gt;&lt;/drools:metaValue&gt;
        &lt;/drools:metaData&gt;
      &lt;/bpmn2:extensionElements&gt;
      &lt;bpmn2:incoming&gt;_00AB4A77-D70F-4086-8BA6-57DD017A5323&lt;/bpmn2:incoming&gt;
      &lt;bpmn2:outgoing&gt;_323FD4C9-FC3D-404F-9156-E3F83B45A799&lt;/bpmn2:outgoing&gt;
      &lt;bpmn2:ioSpecification&gt;
        &lt;bpmn2:dataOutput id=&quot;_3CDC6E61-DCC5-4831-8BBB-417CFF517CB0_coffeesOutputX&quot; drools:dtype=&quot;java.util.Collection&quot; itemSubjectRef=&quot;__3CDC6E61-DCC5-4831-8BBB-417CFF517CB0_coffeesOutputXItem&quot; name=&quot;coffees&quot;/&gt;
        &lt;bpmn2:outputSet&gt;
          &lt;bpmn2:dataOutputRefs&gt;_3CDC6E61-DCC5-4831-8BBB-417CFF517CB0_coffeesOutputX&lt;/bpmn2:dataOutputRefs&gt;
        &lt;/bpmn2:outputSet&gt;
      &lt;/bpmn2:ioSpecification&gt;
      &lt;bpmn2:dataOutputAssociation&gt;
        &lt;bpmn2:sourceRef&gt;_3CDC6E61-DCC5-4831-8BBB-417CFF517CB0_coffeesOutputX&lt;/bpmn2:sourceRef&gt;
        &lt;bpmn2:targetRef&gt;coffees&lt;/bpmn2:targetRef&gt;
      &lt;/bpmn2:dataOutputAssociation&gt;
    &lt;/bpmn2:serviceTask&gt;
    &lt;bpmn2:startEvent id=&quot;_75AC8C0C-CFBD-4ADF-A3B4-83AB90581A73&quot;&gt;
      &lt;bpmn2:outgoing&gt;_00AB4A77-D70F-4086-8BA6-57DD017A5323&lt;/bpmn2:outgoing&gt;
    &lt;/bpmn2:startEvent&gt;
  &lt;/bpmn2:process&gt;
  &lt;bpmndi:BPMNDiagram&gt;
    &lt;bpmndi:BPMNPlane bpmnElement=&quot;coffeeshop&quot;&gt;
      &lt;bpmndi:BPMNShape id=&quot;shape__75AC8C0C-CFBD-4ADF-A3B4-83AB90581A73&quot; bpmnElement=&quot;_75AC8C0C-CFBD-4ADF-A3B4-83AB90581A73&quot;&gt;
        &lt;dc:Bounds height=&quot;56&quot; width=&quot;56&quot; x=&quot;176&quot; y=&quot;198&quot;/&gt;
      &lt;/bpmndi:BPMNShape&gt;
      &lt;bpmndi:BPMNShape id=&quot;shape__3CDC6E61-DCC5-4831-8BBB-417CFF517CB0&quot; bpmnElement=&quot;_3CDC6E61-DCC5-4831-8BBB-417CFF517CB0&quot;&gt;
        &lt;dc:Bounds height=&quot;90&quot; width=&quot;195&quot; x=&quot;326&quot; y=&quot;181&quot;/&gt;
      &lt;/bpmndi:BPMNShape&gt;
      &lt;bpmndi:BPMNShape id=&quot;shape__D74E4311-5CAB-4CBE-9B83-C12961961633&quot; bpmnElement=&quot;_D74E4311-5CAB-4CBE-9B83-C12961961633&quot;&gt;
        &lt;dc:Bounds height=&quot;56&quot; width=&quot;56&quot; x=&quot;641&quot; y=&quot;198&quot;/&gt;
      &lt;/bpmndi:BPMNShape&gt;
      &lt;bpmndi:BPMNEdge id=&quot;edge_shape__75AC8C0C-CFBD-4ADF-A3B4-83AB90581A73_to_shape__3CDC6E61-DCC5-4831-8BBB-417CFF517CB0&quot; bpmnElement=&quot;_00AB4A77-D70F-4086-8BA6-57DD017A5323&quot;&gt;
        &lt;di:waypoint x=&quot;232&quot; y=&quot;226&quot;/&gt;
        &lt;di:waypoint x=&quot;326&quot; y=&quot;226&quot;/&gt;
      &lt;/bpmndi:BPMNEdge&gt;
      &lt;bpmndi:BPMNEdge id=&quot;edge_shape__3CDC6E61-DCC5-4831-8BBB-417CFF517CB0_to_shape__D74E4311-5CAB-4CBE-9B83-C12961961633&quot; bpmnElement=&quot;_323FD4C9-FC3D-404F-9156-E3F83B45A799&quot;&gt;
        &lt;di:waypoint x=&quot;521&quot; y=&quot;226&quot;/&gt;
        &lt;di:waypoint x=&quot;732.5&quot; y=&quot;198&quot;/&gt;
      &lt;/bpmndi:BPMNEdge&gt;
    &lt;/bpmndi:BPMNPlane&gt;
  &lt;/bpmndi:BPMNDiagram&gt;
  &lt;bpmn2:relationship type=&quot;BPSimData&quot;&gt;
    &lt;bpmn2:extensionElements&gt;
      &lt;bpsim:BPSimData&gt;
        &lt;bpsim:Scenario id=&quot;default&quot; name=&quot;Simulationscenario&quot;&gt;
          &lt;bpsim:ScenarioParameters/&gt;
          &lt;bpsim:ElementParameters elementRef=&quot;_75AC8C0C-CFBD-4ADF-A3B4-83AB90581A73&quot;&gt;
            &lt;bpsim:TimeParameters&gt;
              &lt;bpsim:ProcessingTime&gt;
                &lt;bpsim:NormalDistribution mean=&quot;0&quot; standardDeviation=&quot;0&quot;/&gt;
              &lt;/bpsim:ProcessingTime&gt;
            &lt;/bpsim:TimeParameters&gt;
          &lt;/bpsim:ElementParameters&gt;
          &lt;bpsim:ElementParameters elementRef=&quot;_3CDC6E61-DCC5-4831-8BBB-417CFF517CB0&quot;&gt;
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
    &lt;bpmn2:source&gt;_F5Ou4HNMEDig17XG0NHLjQ&lt;/bpmn2:source&gt;
    &lt;bpmn2:target&gt;_F5Ou4HNMEDig17XG0NHLjQ&lt;/bpmn2:target&gt;
  &lt;/bpmn2:relationship&gt;
&lt;/bpmn2:definitions&gt;
</pre>

Note that we've not yet implemented the required CDI beans, therefore we cannot test our process yet. We will implement this CDI bean in the following step.

## Congratulations!

We've created the coffeeshop business process in our Kogito application using BPMN2. In the next step, we will implement the CDI bean that our Service Task is referencing.
