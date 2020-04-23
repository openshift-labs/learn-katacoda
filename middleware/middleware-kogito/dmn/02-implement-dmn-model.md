In the previous step you've created a skeleton Kogito application with Quarkus and started the application in _Quarkus dev-mode_. In this step we'll create the domain model of our application.

## Decision Model & Notation

Decision Model and Notation (DMN) is a standard by the Object Management Group (OMG) for describing and modeling decision logic. It provides a developer and business friendly way to design and model complex decisions using constructs like DRDs (Decision Requirement Diagrams), decision tables, boxed expressions and FEEL (Friendly Enough Expression Language) expressions.

DMN is to decision logic what BPMN is to business process logic.

The Kogito DMN engine is the most powerful DMN decision engine on the market, and the only engine that can run cloud-natively in a container environment.

## Creating the Model

To create our DMN model, we first need to create a new file: `airmiles-service/src/main/resources/airmiles.dmn`{{open}}

DMN uses a graphical modeling language/notation to define decisions. Therefore, Kogito provides a graphical DMN editor as part of its toolset. Apart from providing this editor as an extension to _Visual Studio Code_ and _Red Hat Code Ready Workspaces_, we also  provide this editor online.

You can open the editor by clicking on the "Kogito DMN Tooling" tab next to the "Local Web Browser" tab to open the Kogito DMN Tooling, or navigate to: https://dmn.new

Implement the decision logic as shown in the following video.

https://youtu.be/babjHSNrZBg

After you've defined your DMN model, click on the **Copy to Clipboard** button to copy the DMN XML definition to your clipboard.

Copy the content of your clipboard to the `airmiles-service/src/main/resources/airmiles.dmn` file you've created and opened earlier using `Ctrl+v ` or `Command-v` (depending on your type of computer).

Alternatively, you can copy the following DMN definition to the DMN file:

<pre class="file" data-filename="./airmiles-service/src/main/resources/airmiles.dmn" data-target="replace">
&lt;dmn:definitions xmlns:dmn=&quot;http://www.omg.org/spec/DMN/20180521/MODEL/&quot; xmlns=&quot;https://kiegroup.org/dmn/_35294EAD-600C-4744-A55E-8FF9AF208CA9&quot; xmlns:di=&quot;http://www.omg.org/spec/DMN/20180521/DI/&quot; xmlns:kie=&quot;http://www.drools.org/kie/dmn/1.2&quot; xmlns:dmndi=&quot;http://www.omg.org/spec/DMN/20180521/DMNDI/&quot; xmlns:dc=&quot;http://www.omg.org/spec/DMN/20180521/DC/&quot; xmlns:feel=&quot;http://www.omg.org/spec/DMN/20180521/FEEL/&quot; id=&quot;_D758BDFA-E7F5-4A6A-B23A-FEBB12A53D99&quot; name=&quot;new-file&quot; typeLanguage=&quot;http://www.omg.org/spec/DMN/20180521/FEEL/&quot; namespace=&quot;https://kiegroup.org/dmn/_35294EAD-600C-4744-A55E-8FF9AF208CA9&quot;&gt;
  &lt;dmn:extensionElements/&gt;
  &lt;dmn:itemDefinition id=&quot;_FCFB9FB3-8DD3-4E32-9EEF-83C49281F832&quot; name=&quot;Status&quot; isCollection=&quot;false&quot;&gt;
    &lt;dmn:typeRef&gt;string&lt;/dmn:typeRef&gt;
    &lt;dmn:allowedValues kie:constraintType=&quot;enumeration&quot; id=&quot;_4EB1F55A-9036-40CC-A8E0-E0DC996D69C1&quot;&gt;
      &lt;dmn:text&gt;&quot;NONE&quot;, &quot;GOLD&quot;&lt;/dmn:text&gt;
    &lt;/dmn:allowedValues&gt;
  &lt;/dmn:itemDefinition&gt;
  &lt;dmn:inputData id=&quot;_E3817E6B-8AC8-43A8-85D5-63B392C4D251&quot; name=&quot;Status&quot;&gt;
    &lt;dmn:extensionElements/&gt;
    &lt;dmn:variable id=&quot;_543605A5-2541-411E-9AC0-A3C198236CAA&quot; name=&quot;Status&quot; typeRef=&quot;Status&quot;/&gt;
  &lt;/dmn:inputData&gt;
  &lt;dmn:inputData id=&quot;_2277F609-BE20-48DC-AE6A-479DA027F911&quot; name=&quot;Price&quot;&gt;
    &lt;dmn:extensionElements/&gt;
    &lt;dmn:variable id=&quot;_47643EFF-0E2C-4E42-97B7-8BAEF317FD05&quot; name=&quot;Price&quot; typeRef=&quot;number&quot;/&gt;
  &lt;/dmn:inputData&gt;
  &lt;dmn:decision id=&quot;_25738928-ED07-44D5-9F46-90919A5AEC3A&quot; name=&quot;Airmiles&quot;&gt;
    &lt;dmn:extensionElements/&gt;
    &lt;dmn:variable id=&quot;_C2BFED94-F93B-481A-BACC-5CEA384631E3&quot; name=&quot;Airmiles&quot; typeRef=&quot;number&quot;/&gt;
    &lt;dmn:informationRequirement id=&quot;_49A693BD-5957-4982-B8F4-D0B46FA8A019&quot;&gt;
      &lt;dmn:requiredInput href=&quot;#_E3817E6B-8AC8-43A8-85D5-63B392C4D251&quot;/&gt;
    &lt;/dmn:informationRequirement&gt;
    &lt;dmn:informationRequirement id=&quot;_5120C917-AA9E-4E0E-B7EA-F6F285842B8B&quot;&gt;
      &lt;dmn:requiredInput href=&quot;#_2277F609-BE20-48DC-AE6A-479DA027F911&quot;/&gt;
    &lt;/dmn:informationRequirement&gt;
    &lt;dmn:decisionTable id=&quot;_A28EEEAA-C3F4-4BE3-B558-B38308FF775F&quot; hitPolicy=&quot;UNIQUE&quot; preferredOrientation=&quot;Rule-as-Row&quot;&gt;
      &lt;dmn:input id=&quot;_071F5AB9-C0EC-4A14-BD39-6D85B460D5F0&quot;&gt;
        &lt;dmn:inputExpression id=&quot;_7CA024DC-E1AE-4040-B7AD-FE573D4B77EC&quot; typeRef=&quot;number&quot;&gt;
          &lt;dmn:text&gt;Price&lt;/dmn:text&gt;
        &lt;/dmn:inputExpression&gt;
      &lt;/dmn:input&gt;
      &lt;dmn:input id=&quot;_DE1A8A20-B0E5-4B30-AF89-6699F61476FB&quot;&gt;
        &lt;dmn:inputExpression id=&quot;_584A413F-A0C5-4F7D-BF46-49E735B4377A&quot; typeRef=&quot;string&quot;&gt;
          &lt;dmn:text&gt;Status&lt;/dmn:text&gt;
        &lt;/dmn:inputExpression&gt;
      &lt;/dmn:input&gt;
      &lt;dmn:output id=&quot;_98B31466-2713-43BA-AA4D-613BE1EC03AD&quot;/&gt;
      &lt;dmn:annotation name=&quot;annotation-1&quot;/&gt;
      &lt;dmn:rule id=&quot;_9A72698A-2131-48BF-9394-78A3D2E03454&quot;&gt;
        &lt;dmn:inputEntry id=&quot;_92A7B566-4F6A-4C8C-A6A9-4DF278ADA453&quot;&gt;
          &lt;dmn:text&gt;&amp;lt; 1000&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:inputEntry id=&quot;_019E2507-46BE-4371-9E6E-36FC4CA54959&quot;&gt;
          &lt;dmn:text&gt;&quot;NONE&quot;&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:outputEntry id=&quot;_C3A3B0FF-BDF1-44D2-B1D4-E0CC28E8838A&quot;&gt;
          &lt;dmn:text&gt;Price&lt;/dmn:text&gt;
        &lt;/dmn:outputEntry&gt;
        &lt;dmn:annotationEntry&gt;
          &lt;dmn:text/&gt;
        &lt;/dmn:annotationEntry&gt;
      &lt;/dmn:rule&gt;
      &lt;dmn:rule id=&quot;_4DD69DBB-E9F6-41A4-B788-EECBAC56E306&quot;&gt;
        &lt;dmn:inputEntry id=&quot;_B252A4A5-C7C8-49DE-A22E-B37A90301102&quot;&gt;
          &lt;dmn:text&gt;&amp;lt; 1000&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:inputEntry id=&quot;_2BD67D7C-D620-477D-99C4-8CAA427955CB&quot;&gt;
          &lt;dmn:text&gt;&quot;GOLD&quot;&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:outputEntry id=&quot;_EA37A2DD-A2B1-4602-9A5F-CAB8420D7D88&quot;&gt;
          &lt;dmn:text&gt;Price * 1.2&lt;/dmn:text&gt;
        &lt;/dmn:outputEntry&gt;
        &lt;dmn:annotationEntry&gt;
          &lt;dmn:text/&gt;
        &lt;/dmn:annotationEntry&gt;
      &lt;/dmn:rule&gt;
      &lt;dmn:rule id=&quot;_05B4C161-5D26-4072-989A-7A720CC7A60B&quot;&gt;
        &lt;dmn:inputEntry id=&quot;_D4E6E68B-BBDF-410E-B08F-8A8C9B553900&quot;&gt;
          &lt;dmn:text&gt;&amp;gt;= 1000&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:inputEntry id=&quot;_D0B1B01B-EF7D-4DC5-9D2D-BCCA3AF3606E&quot;&gt;
          &lt;dmn:text&gt;&quot;GOLD&quot;&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:outputEntry id=&quot;_C67181E0-5A9A-4C0E-BA1F-FE2A4C3AB5B7&quot;&gt;
          &lt;dmn:text&gt;Price * 1.5&lt;/dmn:text&gt;
        &lt;/dmn:outputEntry&gt;
        &lt;dmn:annotationEntry&gt;
          &lt;dmn:text/&gt;
        &lt;/dmn:annotationEntry&gt;
      &lt;/dmn:rule&gt;
    &lt;/dmn:decisionTable&gt;
  &lt;/dmn:decision&gt;
  &lt;dmndi:DMNDI&gt;
    &lt;dmndi:DMNDiagram&gt;
      &lt;di:extension&gt;
        &lt;kie:ComponentsWidthsExtension&gt;
          &lt;kie:ComponentWidths dmnElementRef=&quot;_A28EEEAA-C3F4-4BE3-B558-B38308FF775F&quot;&gt;
            &lt;kie:width&gt;50&lt;/kie:width&gt;
            &lt;kie:width&gt;100&lt;/kie:width&gt;
            &lt;kie:width&gt;100&lt;/kie:width&gt;
            &lt;kie:width&gt;100&lt;/kie:width&gt;
            &lt;kie:width&gt;100&lt;/kie:width&gt;
          &lt;/kie:ComponentWidths&gt;
        &lt;/kie:ComponentsWidthsExtension&gt;
      &lt;/di:extension&gt;
      &lt;dmndi:DMNShape id=&quot;dmnshape-_E3817E6B-8AC8-43A8-85D5-63B392C4D251&quot; dmnElementRef=&quot;_E3817E6B-8AC8-43A8-85D5-63B392C4D251&quot; isCollapsed=&quot;false&quot;&gt;
        &lt;dmndi:DMNStyle&gt;
          &lt;dmndi:FillColor red=&quot;255&quot; green=&quot;255&quot; blue=&quot;255&quot;/&gt;
          &lt;dmndi:StrokeColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
          &lt;dmndi:FontColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
        &lt;/dmndi:DMNStyle&gt;
        &lt;dc:Bounds x=&quot;408&quot; y=&quot;389&quot; width=&quot;100&quot; height=&quot;50&quot;/&gt;
        &lt;dmndi:DMNLabel/&gt;
      &lt;/dmndi:DMNShape&gt;
      &lt;dmndi:DMNShape id=&quot;dmnshape-_2277F609-BE20-48DC-AE6A-479DA027F911&quot; dmnElementRef=&quot;_2277F609-BE20-48DC-AE6A-479DA027F911&quot; isCollapsed=&quot;false&quot;&gt;
        &lt;dmndi:DMNStyle&gt;
          &lt;dmndi:FillColor red=&quot;255&quot; green=&quot;255&quot; blue=&quot;255&quot;/&gt;
          &lt;dmndi:StrokeColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
          &lt;dmndi:FontColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
        &lt;/dmndi:DMNStyle&gt;
        &lt;dc:Bounds x=&quot;630&quot; y=&quot;389&quot; width=&quot;100&quot; height=&quot;50&quot;/&gt;
        &lt;dmndi:DMNLabel/&gt;
      &lt;/dmndi:DMNShape&gt;
      &lt;dmndi:DMNShape id=&quot;dmnshape-_25738928-ED07-44D5-9F46-90919A5AEC3A&quot; dmnElementRef=&quot;_25738928-ED07-44D5-9F46-90919A5AEC3A&quot; isCollapsed=&quot;false&quot;&gt;
        &lt;dmndi:DMNStyle&gt;
          &lt;dmndi:FillColor red=&quot;255&quot; green=&quot;255&quot; blue=&quot;255&quot;/&gt;
          &lt;dmndi:StrokeColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
          &lt;dmndi:FontColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
        &lt;/dmndi:DMNStyle&gt;
        &lt;dc:Bounds x=&quot;531&quot; y=&quot;240&quot; width=&quot;100&quot; height=&quot;50&quot;/&gt;
        &lt;dmndi:DMNLabel/&gt;
      &lt;/dmndi:DMNShape&gt;
      &lt;dmndi:DMNEdge id=&quot;dmnedge-_49A693BD-5957-4982-B8F4-D0B46FA8A019&quot; dmnElementRef=&quot;_49A693BD-5957-4982-B8F4-D0B46FA8A019&quot;&gt;
        &lt;di:waypoint x=&quot;458&quot; y=&quot;414&quot;/&gt;
        &lt;di:waypoint x=&quot;581&quot; y=&quot;290&quot;/&gt;
      &lt;/dmndi:DMNEdge&gt;
      &lt;dmndi:DMNEdge id=&quot;dmnedge-_5120C917-AA9E-4E0E-B7EA-F6F285842B8B&quot; dmnElementRef=&quot;_5120C917-AA9E-4E0E-B7EA-F6F285842B8B&quot;&gt;
        &lt;di:waypoint x=&quot;680&quot; y=&quot;414&quot;/&gt;
        &lt;di:waypoint x=&quot;581&quot; y=&quot;265&quot;/&gt;
      &lt;/dmndi:DMNEdge&gt;
    &lt;/dmndi:DMNDiagram&gt;
  &lt;/dmndi:DMNDI&gt;
&lt;/dmn:definitions&gt;
</pre>

Since we still have our app running using `mvn quarkus:dev`, when you make these changes and reload the endpoint, Quarkus will notice all of these changes and live-reload them, including changes in your business assets (i.e. processes, decision, rules, etc.).

Check that it works as expected by opening the Swagger-UI endpoint by [clicking here](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui). The Swagger-UI will show the REST resources that have been generated from the project's _business assets_, in this case the `/airmiles` resource, which is backed by our DMN decision model.

## Test the application.

To test the application, we can simply send a RESTful request to it using cURL. By clicking the following command, we send a request that determines the number of airmiles a traveller with a _GOLD_ status gets for a flight with a price of 600:

`curl -X POST 'http://localhost:8080/airmiles' -H 'Accept: application/json' -H 'Content-Type: application/json' -d '{ "Status": "GOLD",	"Price": 600}'`{{execute T2}}

You will get the following result:

```console
{"Status":"GOLD","Airmiles":720.0,"Price":600}
```

We can see that our DMN decision logic has determined that the number of airmiles is 720, which is 1.2 times the price of the flight.

You can now stop the application in the first terminal using `CTRL-C`.

## Congratulations!

You've implemented your first DMN model using the Kogito Online DMN editor. Using the hot/live reload capabilities of Quarkus, we've seen how these changes are immediately reflected in our Swagger UI. Finally, you've fired a RESTful request to our DMN decision microservice and saw cloud-native decisioning with DMN in action.
