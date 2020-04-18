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
&lt;dmn:definitions xmlns:dmn=&quot;http://www.omg.org/spec/DMN/20180521/MODEL/&quot; xmlns=&quot;https://kiegroup.org/dmn/_B298D71D-7E1C-4289-9077-63BFC3575691&quot; xmlns:di=&quot;http://www.omg.org/spec/DMN/20180521/DI/&quot; xmlns:kie=&quot;http://www.drools.org/kie/dmn/1.2&quot; xmlns:dmndi=&quot;http://www.omg.org/spec/DMN/20180521/DMNDI/&quot; xmlns:dc=&quot;http://www.omg.org/spec/DMN/20180521/DC/&quot; xmlns:feel=&quot;http://www.omg.org/spec/DMN/20180521/FEEL/&quot; id=&quot;_C5BF559F-4EFC-4545-8A90-2FAD7B3B54EF&quot; name=&quot;airmiles&quot; typeLanguage=&quot;http://www.omg.org/spec/DMN/20180521/FEEL/&quot; namespace=&quot;https://kiegroup.org/dmn/_B298D71D-7E1C-4289-9077-63BFC3575691&quot;&gt;
  &lt;dmn:extensionElements/&gt;
  &lt;dmn:itemDefinition id=&quot;_998FB58E-AF5F-45BF-B98A-A4CBD41B15F9&quot; name=&quot;Status&quot; isCollection=&quot;false&quot;&gt;
    &lt;dmn:typeRef&gt;string&lt;/dmn:typeRef&gt;
    &lt;dmn:allowedValues kie:constraintType=&quot;enumeration&quot; id=&quot;_DB5ECD03-DE8C-47FD-8A00-CB4E4A58BD74&quot;&gt;
      &lt;dmn:text&gt;&quot;NONE&quot;, &quot;GOLD&quot;&lt;/dmn:text&gt;
    &lt;/dmn:allowedValues&gt;
  &lt;/dmn:itemDefinition&gt;
  &lt;dmn:inputData id=&quot;_2DC3D0D9-7095-4937-A984-05644ABF651E&quot; name=&quot;Status&quot;&gt;
    &lt;dmn:extensionElements/&gt;
    &lt;dmn:variable id=&quot;_ED2034F4-C40C-45FC-A085-82C4F79850FC&quot; name=&quot;Status&quot; typeRef=&quot;Status&quot;/&gt;
  &lt;/dmn:inputData&gt;
  &lt;dmn:inputData id=&quot;_CFC11C0F-61ED-4894-9A91-C00323ECA034&quot; name=&quot;Price&quot;&gt;
    &lt;dmn:extensionElements/&gt;
    &lt;dmn:variable id=&quot;_4DC6D12B-7F30-4401-B977-8CD71AA602B3&quot; name=&quot;Price&quot; typeRef=&quot;number&quot;/&gt;
  &lt;/dmn:inputData&gt;
  &lt;dmn:decision id=&quot;_0F5C7423-AF66-41E8-ACF3-7DCF0CFC3A12&quot; name=&quot;Airmiles&quot;&gt;
    &lt;dmn:extensionElements/&gt;
    &lt;dmn:variable id=&quot;_036BE161-82F1-4F02-89C5-8EDBB0756E6E&quot; name=&quot;Airmiles&quot;/&gt;
    &lt;dmn:informationRequirement id=&quot;_6352EB77-B695-4870-974A-141E8EC8FD59&quot;&gt;
      &lt;dmn:requiredInput href=&quot;#_2DC3D0D9-7095-4937-A984-05644ABF651E&quot;/&gt;
    &lt;/dmn:informationRequirement&gt;
    &lt;dmn:informationRequirement id=&quot;_81ACBB53-5BB7-4A6E-9788-506669E2633B&quot;&gt;
      &lt;dmn:requiredInput href=&quot;#_CFC11C0F-61ED-4894-9A91-C00323ECA034&quot;/&gt;
    &lt;/dmn:informationRequirement&gt;
    &lt;dmn:decisionTable id=&quot;_CEDBBDEC-1DC2-4BD5-B081-3E5CCEF006AD&quot; hitPolicy=&quot;UNIQUE&quot; preferredOrientation=&quot;Rule-as-Row&quot;&gt;
      &lt;dmn:input id=&quot;_143C38FE-5952-4EE0-A7A0-12B73C7ECA95&quot;&gt;
        &lt;dmn:inputExpression id=&quot;_539A482B-995D-497B-A4E2-9394606E2C35&quot; typeRef=&quot;number&quot;&gt;
          &lt;dmn:text&gt;Price&lt;/dmn:text&gt;
        &lt;/dmn:inputExpression&gt;
      &lt;/dmn:input&gt;
      &lt;dmn:input id=&quot;_66BC9B51-B6FD-4C4C-9F99-FC628E82E63D&quot;&gt;
        &lt;dmn:inputExpression id=&quot;_42F2C965-B260-479D-BBDF-0072F9098384&quot; typeRef=&quot;string&quot;&gt;
          &lt;dmn:text&gt;Status&lt;/dmn:text&gt;
        &lt;/dmn:inputExpression&gt;
      &lt;/dmn:input&gt;
      &lt;dmn:output id=&quot;_51186FBA-7EF7-4785-ABB8-F7AF66C0B161&quot;/&gt;
      &lt;dmn:annotation name=&quot;annotation-1&quot;/&gt;
      &lt;dmn:rule id=&quot;_8986B432-5E20-48D5-8DB8-2B0D1889F930&quot;&gt;
        &lt;dmn:inputEntry id=&quot;_1623F09B-169D-43D5-A663-502AADA39254&quot;&gt;
          &lt;dmn:text&gt;&amp;lt; 1000&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:inputEntry id=&quot;_A1F9CF5E-6FFA-466A-B6D9-EA94300797B7&quot;&gt;
          &lt;dmn:text&gt;&quot;NONE&quot;&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:outputEntry id=&quot;_2AA5FABD-CD30-4531-8CBD-EC092B93AA03&quot;&gt;
          &lt;dmn:text&gt;Price&lt;/dmn:text&gt;
        &lt;/dmn:outputEntry&gt;
        &lt;dmn:annotationEntry&gt;
          &lt;dmn:text/&gt;
        &lt;/dmn:annotationEntry&gt;
      &lt;/dmn:rule&gt;
      &lt;dmn:rule id=&quot;_9A28ABA1-39EA-4F65-A6C8-CF58B9FB2AB0&quot;&gt;
        &lt;dmn:inputEntry id=&quot;_795519A9-819E-4F2B-99B7-E8F466AC0C64&quot;&gt;
          &lt;dmn:text&gt;&amp;lt; 1000&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:inputEntry id=&quot;_8E094135-554D-4C97-AA03-66A3671AF025&quot;&gt;
          &lt;dmn:text&gt;&quot;GOLD&quot;&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:outputEntry id=&quot;_7BEEE2D8-8D7E-404F-93FA-78427B4D3905&quot;&gt;
          &lt;dmn:text&gt;Price * 1.2&lt;/dmn:text&gt;
        &lt;/dmn:outputEntry&gt;
        &lt;dmn:annotationEntry&gt;
          &lt;dmn:text/&gt;
        &lt;/dmn:annotationEntry&gt;
      &lt;/dmn:rule&gt;
      &lt;dmn:rule id=&quot;_868F6C30-FD4F-4174-81A0-80CC8F4B94D4&quot;&gt;
        &lt;dmn:inputEntry id=&quot;_1BFC1692-11AC-4E7E-A046-53A3A60CC0DC&quot;&gt;
          &lt;dmn:text&gt;&amp;gt;= 1000&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:inputEntry id=&quot;_230C9E92-E11A-4239-B3B0-07F8ABEC582E&quot;&gt;
          &lt;dmn:text&gt;&quot;GOLD&quot;&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:outputEntry id=&quot;_57160E91-4F88-41D1-BBF2-1CD5E44A0A8F&quot;&gt;
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
          &lt;kie:ComponentWidths dmnElementRef=&quot;_CEDBBDEC-1DC2-4BD5-B081-3E5CCEF006AD&quot;&gt;
            &lt;kie:width&gt;50&lt;/kie:width&gt;
            &lt;kie:width&gt;100&lt;/kie:width&gt;
            &lt;kie:width&gt;100&lt;/kie:width&gt;
            &lt;kie:width&gt;100&lt;/kie:width&gt;
            &lt;kie:width&gt;100&lt;/kie:width&gt;
          &lt;/kie:ComponentWidths&gt;
        &lt;/kie:ComponentsWidthsExtension&gt;
      &lt;/di:extension&gt;
      &lt;dmndi:DMNShape id=&quot;dmnshape-_2DC3D0D9-7095-4937-A984-05644ABF651E&quot; dmnElementRef=&quot;_2DC3D0D9-7095-4937-A984-05644ABF651E&quot; isCollapsed=&quot;false&quot;&gt;
        &lt;dmndi:DMNStyle&gt;
          &lt;dmndi:FillColor red=&quot;255&quot; green=&quot;255&quot; blue=&quot;255&quot;/&gt;
          &lt;dmndi:StrokeColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
          &lt;dmndi:FontColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
        &lt;/dmndi:DMNStyle&gt;
        &lt;dc:Bounds x=&quot;220&quot; y=&quot;235&quot; width=&quot;100&quot; height=&quot;50&quot;/&gt;
        &lt;dmndi:DMNLabel/&gt;
      &lt;/dmndi:DMNShape&gt;
      &lt;dmndi:DMNShape id=&quot;dmnshape-_CFC11C0F-61ED-4894-9A91-C00323ECA034&quot; dmnElementRef=&quot;_CFC11C0F-61ED-4894-9A91-C00323ECA034&quot; isCollapsed=&quot;false&quot;&gt;
        &lt;dmndi:DMNStyle&gt;
          &lt;dmndi:FillColor red=&quot;255&quot; green=&quot;255&quot; blue=&quot;255&quot;/&gt;
          &lt;dmndi:StrokeColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
          &lt;dmndi:FontColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
        &lt;/dmndi:DMNStyle&gt;
        &lt;dc:Bounds x=&quot;405&quot; y=&quot;235&quot; width=&quot;100&quot; height=&quot;50&quot;/&gt;
        &lt;dmndi:DMNLabel/&gt;
      &lt;/dmndi:DMNShape&gt;
      &lt;dmndi:DMNShape id=&quot;dmnshape-_0F5C7423-AF66-41E8-ACF3-7DCF0CFC3A12&quot; dmnElementRef=&quot;_0F5C7423-AF66-41E8-ACF3-7DCF0CFC3A12&quot; isCollapsed=&quot;false&quot;&gt;
        &lt;dmndi:DMNStyle&gt;
          &lt;dmndi:FillColor red=&quot;255&quot; green=&quot;255&quot; blue=&quot;255&quot;/&gt;
          &lt;dmndi:StrokeColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
          &lt;dmndi:FontColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
        &lt;/dmndi:DMNStyle&gt;
        &lt;dc:Bounds x=&quot;313&quot; y=&quot;97&quot; width=&quot;100&quot; height=&quot;50&quot;/&gt;
        &lt;dmndi:DMNLabel/&gt;
      &lt;/dmndi:DMNShape&gt;
      &lt;dmndi:DMNEdge id=&quot;dmnedge-_6352EB77-B695-4870-974A-141E8EC8FD59&quot; dmnElementRef=&quot;_6352EB77-B695-4870-974A-141E8EC8FD59&quot;&gt;
        &lt;di:waypoint x=&quot;270&quot; y=&quot;260&quot;/&gt;
        &lt;di:waypoint x=&quot;363&quot; y=&quot;147&quot;/&gt;
      &lt;/dmndi:DMNEdge&gt;
      &lt;dmndi:DMNEdge id=&quot;dmnedge-_81ACBB53-5BB7-4A6E-9788-506669E2633B&quot; dmnElementRef=&quot;_81ACBB53-5BB7-4A6E-9788-506669E2633B&quot;&gt;
        &lt;di:waypoint x=&quot;455&quot; y=&quot;260&quot;/&gt;
        &lt;di:waypoint x=&quot;363&quot; y=&quot;122&quot;/&gt;
      &lt;/dmndi:DMNEdge&gt;
    &lt;/dmndi:DMNDiagram&gt;
  &lt;/dmndi:DMNDI&gt;
&lt;/dmn:definitions&gt;
</pre>

Since we still have our app running using `mvn quarkus:dev`, when you make these changes and reload the endpoint, Quarkus will notice all of these changes and live-reload them, including changes in your business assets (i.e. processes, decision, rules, etc.).

Check that it works as expected by opening the Swagger-UI endpoint by [clicking here](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui). The Swagger-UI will show the REST resources that have been generated from the project's _business assets_, in this case the `/airmiles` resource, which is backed by our DMN decision model.

## Test the application.

To test the application, we can simply send a RESTful request to it using cURL. By clicking the following command, we send a request that determines the number of airmiles a traveller with a _GOLD_ status gets for a flight with a price of 600:

`curl -X POST 'http://localhost:8080/airmiles' -H 'Accept: application/json' -H 'Content-Type: application/json' -d '{ "Status": "GOLD",	"Price": 600}'`

You will get the following result:

```console
{"Status":"GOLD","Airmiles":720.0,"Price":600}
```

We can see that our DMN decision logic has determined that the number of airmiles is 720, which is 1.2 times the price of the flight.

## Congratulations!

You've implemented your first DMN model using the Kogito Online DMN editor. Using the hot/live reload capabilities of Quarkus, we've seen how these changes are immediately reflected in our Swagger UI. Finally, you've fired a RESTful request to our DMN decision microservice and saw cloud-native decisioning with DMN in action.
