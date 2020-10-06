In the previous step you've created a skeleton Kogito application with Quarkus and started the application in _Quarkus dev-mode_. In this step we'll create the domain model of our application.

## Decision Model & Notation

Decision Model and Notation (DMN) is a standard by the Object Management Group (OMG) for describing and modeling decision logic. It provides a developer and business friendly way to design and model complex decisions using constructs like DRDs (Decision Requirement Diagrams), decision tables, boxed expressions and FEEL (Friendly Enough Expression Language) expressions.

DMN is to decision logic what BPMN is to business process logic.

The Kogito DMN engine is the most powerful DMN decision engine on the market, and the only engine that can run cloud-natively in a container environment.

## Creating the Model

To create our DMN model, we first need to create a new file: `airmiles-service/src/main/resources/airmiles.dmn`{{open}}

DMN uses a graphical modeling language/notation to define decisions. Therefore, Kogito provides a graphical DMN editor as part of its toolset. Apart from providing this editor as an extension to _Visual Studio Code_ and _Red Hat Code Ready Workspaces_, we also  provide this editor online.

You can open the editor by clicking on the "Kogito DMN Tooling" tab next to the "OpenShift Console" tab to open the Kogito DMN Tooling, or navigate to: https://dmn.new

Implement the decision logic as shown in the following video.

https://youtu.be/NAO0eV5c5tE

After you've defined your DMN model, click on the **Copy to Clipboard** button to copy the DMN XML definition to your clipboard.

Copy the content of your clipboard to the `airmiles-service/src/main/resources/airmiles.dmn` file you've created and opened earlier using `Ctrl+v ` or `Command-v` (depending on your type of computer).

Alternatively, you can copy the following DMN definition to the DMN file:

<pre class="file" data-filename="./airmiles-service/src/main/resources/airmiles.dmn" data-target="replace">
&lt;dmn:definitions xmlns:dmn=&quot;http://www.omg.org/spec/DMN/20180521/MODEL/&quot; xmlns=&quot;https://kiegroup.org/dmn/_5D27A744-6EE3-4BC6-B891-9A8669912C99&quot; xmlns:di=&quot;http://www.omg.org/spec/DMN/20180521/DI/&quot; xmlns:kie=&quot;http://www.drools.org/kie/dmn/1.2&quot; xmlns:dmndi=&quot;http://www.omg.org/spec/DMN/20180521/DMNDI/&quot; xmlns:dc=&quot;http://www.omg.org/spec/DMN/20180521/DC/&quot; xmlns:feel=&quot;http://www.omg.org/spec/DMN/20180521/FEEL/&quot; id=&quot;_114F5D03-A27F-437C-9078-743D9F77C0BE&quot; name=&quot;airmiles&quot; typeLanguage=&quot;http://www.omg.org/spec/DMN/20180521/FEEL/&quot; namespace=&quot;https://kiegroup.org/dmn/_5D27A744-6EE3-4BC6-B891-9A8669912C99&quot;&gt;
  &lt;dmn:extensionElements/&gt;
  &lt;dmn:itemDefinition id=&quot;_3ACF44E4-CC55-4609-A10F-D763EA91CFF9&quot; name=&quot;Status&quot; isCollection=&quot;false&quot;&gt;
    &lt;dmn:typeRef&gt;string&lt;/dmn:typeRef&gt;
    &lt;dmn:allowedValues kie:constraintType=&quot;enumeration&quot; id=&quot;_53BADE3B-9AAB-4B8B-BD94-89B92791C90E&quot;&gt;
      &lt;dmn:text&gt;&quot;NONE&quot;, &quot;GOLD&quot;&lt;/dmn:text&gt;
    &lt;/dmn:allowedValues&gt;
  &lt;/dmn:itemDefinition&gt;
  &lt;dmn:inputData id=&quot;_971CFFCA-D632-4D9E-907E-6039B4D637C4&quot; name=&quot;Status&quot;&gt;
    &lt;dmn:extensionElements/&gt;
    &lt;dmn:variable id=&quot;_E5F7E161-8BCB-4DF8-BD8D-31985886191A&quot; name=&quot;Status&quot; typeRef=&quot;Status&quot;/&gt;
  &lt;/dmn:inputData&gt;
  &lt;dmn:inputData id=&quot;_BA21F901-A388-4AA1-A2E3-9B851C3B4D51&quot; name=&quot;Price&quot;&gt;
    &lt;dmn:extensionElements/&gt;
    &lt;dmn:variable id=&quot;_291D47E7-08BC-46A8-9F76-90833F4663CA&quot; name=&quot;Price&quot; typeRef=&quot;number&quot;/&gt;
  &lt;/dmn:inputData&gt;
  &lt;dmn:decision id=&quot;_19410C4E-DBDB-40C0-9FD6-ED1BD2E45E7F&quot; name=&quot;Airmiles&quot;&gt;
    &lt;dmn:extensionElements/&gt;
    &lt;dmn:variable id=&quot;_C1CC187F-A475-42D2-B1EE-D1E932F271C6&quot; name=&quot;Airmiles&quot; typeRef=&quot;number&quot;/&gt;
    &lt;dmn:informationRequirement id=&quot;_141FFE64-867C-4518-B1F6-445132968CB3&quot;&gt;
      &lt;dmn:requiredInput href=&quot;#_971CFFCA-D632-4D9E-907E-6039B4D637C4&quot;/&gt;
    &lt;/dmn:informationRequirement&gt;
    &lt;dmn:informationRequirement id=&quot;_651F6C66-FADB-4649-B5B4-8203E6207335&quot;&gt;
      &lt;dmn:requiredInput href=&quot;#_BA21F901-A388-4AA1-A2E3-9B851C3B4D51&quot;/&gt;
    &lt;/dmn:informationRequirement&gt;
    &lt;dmn:decisionTable id=&quot;_98D848C5-E990-4728-82FC-ADF33DD1919E&quot; hitPolicy=&quot;UNIQUE&quot; preferredOrientation=&quot;Rule-as-Row&quot;&gt;
      &lt;dmn:input id=&quot;_55D26D4E-D92B-47BC-B496-3747D77EA0B6&quot;&gt;
        &lt;dmn:inputExpression id=&quot;_9EC311C3-2140-43B3-A141-8A42DB00DB8D&quot; typeRef=&quot;number&quot;&gt;
          &lt;dmn:text&gt;Price&lt;/dmn:text&gt;
        &lt;/dmn:inputExpression&gt;
      &lt;/dmn:input&gt;
      &lt;dmn:input id=&quot;_84F3F5C1-79B5-409C-BCC0-97B396E28DD1&quot;&gt;
        &lt;dmn:inputExpression id=&quot;_C62A3044-C6A6-48D8-872D-5B330E0C8047&quot; typeRef=&quot;string&quot;&gt;
          &lt;dmn:text&gt;Status&lt;/dmn:text&gt;
        &lt;/dmn:inputExpression&gt;
      &lt;/dmn:input&gt;
      &lt;dmn:output id=&quot;_544D2FEB-B841-4B61-B122-68A1C395832C&quot;/&gt;
      &lt;dmn:annotation name=&quot;annotation-1&quot;/&gt;
      &lt;dmn:rule id=&quot;_CDB2D0AC-ECDF-4C74-8A32-682069C91859&quot;&gt;
        &lt;dmn:inputEntry id=&quot;_B165ED8B-A3A4-4B3B-889C-08593C8F9A87&quot;&gt;
          &lt;dmn:text&gt;&amp;lt; 1000&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:inputEntry id=&quot;_05887514-1C17-4C71-B8EC-AD08EC30C0CF&quot;&gt;
          &lt;dmn:text&gt;&quot;NONE&quot;&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:outputEntry id=&quot;_6619706E-377A-478F-A65B-47446C49EEEB&quot;&gt;
          &lt;dmn:text&gt;Price&lt;/dmn:text&gt;
        &lt;/dmn:outputEntry&gt;
        &lt;dmn:annotationEntry&gt;
          &lt;dmn:text/&gt;
        &lt;/dmn:annotationEntry&gt;
      &lt;/dmn:rule&gt;
      &lt;dmn:rule id=&quot;_676E3049-FFB1-4632-B9D0-4306844F5253&quot;&gt;
        &lt;dmn:inputEntry id=&quot;_F5048041-1FB8-4259-96BC-AF0AC391CB61&quot;&gt;
          &lt;dmn:text&gt;&amp;lt; 1000&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:inputEntry id=&quot;_DA250570-96EC-4054-81FE-D0E975A5F365&quot;&gt;
          &lt;dmn:text&gt;&quot;GOLD&quot;&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:outputEntry id=&quot;_20BB6BFE-4762-4280-9EF2-5FE9431645B2&quot;&gt;
          &lt;dmn:text&gt;Price * 1.2&lt;/dmn:text&gt;
        &lt;/dmn:outputEntry&gt;
        &lt;dmn:annotationEntry&gt;
          &lt;dmn:text/&gt;
        &lt;/dmn:annotationEntry&gt;
      &lt;/dmn:rule&gt;
      &lt;dmn:rule id=&quot;_D5FF84FB-5746-4980-957E-F054C8957D2D&quot;&gt;
        &lt;dmn:inputEntry id=&quot;_5F8CCCF6-3910-4E36-AC64-C84E53B49E01&quot;&gt;
          &lt;dmn:text&gt;&amp;gt;= 1000&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:inputEntry id=&quot;_2D8FC50E-625A-4BAC-B5C5-5DBE0BD14991&quot;&gt;
          &lt;dmn:text&gt;&quot;GOLD&quot;&lt;/dmn:text&gt;
        &lt;/dmn:inputEntry&gt;
        &lt;dmn:outputEntry id=&quot;_5B55D92F-16C8-42B1-8302-26D9BC21EE3A&quot;&gt;
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
          &lt;kie:ComponentWidths dmnElementRef=&quot;_98D848C5-E990-4728-82FC-ADF33DD1919E&quot;&gt;
            &lt;kie:width&gt;50&lt;/kie:width&gt;
            &lt;kie:width&gt;100&lt;/kie:width&gt;
            &lt;kie:width&gt;100&lt;/kie:width&gt;
            &lt;kie:width&gt;100&lt;/kie:width&gt;
            &lt;kie:width&gt;100&lt;/kie:width&gt;
          &lt;/kie:ComponentWidths&gt;
        &lt;/kie:ComponentsWidthsExtension&gt;
      &lt;/di:extension&gt;
      &lt;dmndi:DMNShape id=&quot;dmnshape-_971CFFCA-D632-4D9E-907E-6039B4D637C4&quot; dmnElementRef=&quot;_971CFFCA-D632-4D9E-907E-6039B4D637C4&quot; isCollapsed=&quot;false&quot;&gt;
        &lt;dmndi:DMNStyle&gt;
          &lt;dmndi:FillColor red=&quot;255&quot; green=&quot;255&quot; blue=&quot;255&quot;/&gt;
          &lt;dmndi:StrokeColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
          &lt;dmndi:FontColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
        &lt;/dmndi:DMNStyle&gt;
        &lt;dc:Bounds x=&quot;346&quot; y=&quot;322&quot; width=&quot;100&quot; height=&quot;50&quot;/&gt;
        &lt;dmndi:DMNLabel/&gt;
      &lt;/dmndi:DMNShape&gt;
      &lt;dmndi:DMNShape id=&quot;dmnshape-_BA21F901-A388-4AA1-A2E3-9B851C3B4D51&quot; dmnElementRef=&quot;_BA21F901-A388-4AA1-A2E3-9B851C3B4D51&quot; isCollapsed=&quot;false&quot;&gt;
        &lt;dmndi:DMNStyle&gt;
          &lt;dmndi:FillColor red=&quot;255&quot; green=&quot;255&quot; blue=&quot;255&quot;/&gt;
          &lt;dmndi:StrokeColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
          &lt;dmndi:FontColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
        &lt;/dmndi:DMNStyle&gt;
        &lt;dc:Bounds x=&quot;554&quot; y=&quot;322&quot; width=&quot;100&quot; height=&quot;50&quot;/&gt;
        &lt;dmndi:DMNLabel/&gt;
      &lt;/dmndi:DMNShape&gt;
      &lt;dmndi:DMNShape id=&quot;dmnshape-_19410C4E-DBDB-40C0-9FD6-ED1BD2E45E7F&quot; dmnElementRef=&quot;_19410C4E-DBDB-40C0-9FD6-ED1BD2E45E7F&quot; isCollapsed=&quot;false&quot;&gt;
        &lt;dmndi:DMNStyle&gt;
          &lt;dmndi:FillColor red=&quot;255&quot; green=&quot;255&quot; blue=&quot;255&quot;/&gt;
          &lt;dmndi:StrokeColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
          &lt;dmndi:FontColor red=&quot;0&quot; green=&quot;0&quot; blue=&quot;0&quot;/&gt;
        &lt;/dmndi:DMNStyle&gt;
        &lt;dc:Bounds x=&quot;451&quot; y=&quot;188&quot; width=&quot;100&quot; height=&quot;50&quot;/&gt;
        &lt;dmndi:DMNLabel/&gt;
      &lt;/dmndi:DMNShape&gt;
      &lt;dmndi:DMNEdge id=&quot;dmnedge-_141FFE64-867C-4518-B1F6-445132968CB3&quot; dmnElementRef=&quot;_141FFE64-867C-4518-B1F6-445132968CB3&quot;&gt;
        &lt;di:waypoint x=&quot;396&quot; y=&quot;347&quot;/&gt;
        &lt;di:waypoint x=&quot;501&quot; y=&quot;238&quot;/&gt;
      &lt;/dmndi:DMNEdge&gt;
      &lt;dmndi:DMNEdge id=&quot;dmnedge-_651F6C66-FADB-4649-B5B4-8203E6207335&quot; dmnElementRef=&quot;_651F6C66-FADB-4649-B5B4-8203E6207335&quot;&gt;
        &lt;di:waypoint x=&quot;604&quot; y=&quot;347&quot;/&gt;
        &lt;di:waypoint x=&quot;501&quot; y=&quot;213&quot;/&gt;
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
