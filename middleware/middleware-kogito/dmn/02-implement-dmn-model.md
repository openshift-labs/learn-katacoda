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
<dmn:definitions xmlns:dmn="http://www.omg.org/spec/DMN/20180521/MODEL/" xmlns="https://kiegroup.org/dmn/_B298D71D-7E1C-4289-9077-63BFC3575691" xmlns:di="http://www.omg.org/spec/DMN/20180521/DI/" xmlns:kie="http://www.drools.org/kie/dmn/1.2" xmlns:dmndi="http://www.omg.org/spec/DMN/20180521/DMNDI/" xmlns:dc="http://www.omg.org/spec/DMN/20180521/DC/" xmlns:feel="http://www.omg.org/spec/DMN/20180521/FEEL/" id="_C5BF559F-4EFC-4545-8A90-2FAD7B3B54EF" name="airmiles" typeLanguage="http://www.omg.org/spec/DMN/20180521/FEEL/" namespace="https://kiegroup.org/dmn/_B298D71D-7E1C-4289-9077-63BFC3575691">
  <dmn:extensionElements/>
  <dmn:itemDefinition id="_998FB58E-AF5F-45BF-B98A-A4CBD41B15F9" name="Status" isCollection="false">
    <dmn:typeRef>string</dmn:typeRef>
    <dmn:allowedValues kie:constraintType="enumeration" id="_DB5ECD03-DE8C-47FD-8A00-CB4E4A58BD74">
      <dmn:text>"NONE", "GOLD"</dmn:text>
    </dmn:allowedValues>
  </dmn:itemDefinition>
  <dmn:inputData id="_2DC3D0D9-7095-4937-A984-05644ABF651E" name="Status">
    <dmn:extensionElements/>
    <dmn:variable id="_ED2034F4-C40C-45FC-A085-82C4F79850FC" name="Status" typeRef="Status"/>
  </dmn:inputData>
  <dmn:inputData id="_CFC11C0F-61ED-4894-9A91-C00323ECA034" name="Price">
    <dmn:extensionElements/>
    <dmn:variable id="_4DC6D12B-7F30-4401-B977-8CD71AA602B3" name="Price" typeRef="number"/>
  </dmn:inputData>
  <dmn:decision id="_0F5C7423-AF66-41E8-ACF3-7DCF0CFC3A12" name="Airmiles">
    <dmn:extensionElements/>
    <dmn:variable id="_036BE161-82F1-4F02-89C5-8EDBB0756E6E" name="Airmiles"/>
    <dmn:informationRequirement id="_6352EB77-B695-4870-974A-141E8EC8FD59">
      <dmn:requiredInput href="#_2DC3D0D9-7095-4937-A984-05644ABF651E"/>
    </dmn:informationRequirement>
    <dmn:informationRequirement id="_81ACBB53-5BB7-4A6E-9788-506669E2633B">
      <dmn:requiredInput href="#_CFC11C0F-61ED-4894-9A91-C00323ECA034"/>
    </dmn:informationRequirement>
    <dmn:decisionTable id="_CEDBBDEC-1DC2-4BD5-B081-3E5CCEF006AD" hitPolicy="UNIQUE" preferredOrientation="Rule-as-Row">
      <dmn:input id="_143C38FE-5952-4EE0-A7A0-12B73C7ECA95">
        <dmn:inputExpression id="_539A482B-995D-497B-A4E2-9394606E2C35" typeRef="number">
          <dmn:text>Price</dmn:text>
        </dmn:inputExpression>
      </dmn:input>
      <dmn:input id="_66BC9B51-B6FD-4C4C-9F99-FC628E82E63D">
        <dmn:inputExpression id="_42F2C965-B260-479D-BBDF-0072F9098384" typeRef="string">
          <dmn:text>Status</dmn:text>
        </dmn:inputExpression>
      </dmn:input>
      <dmn:output id="_51186FBA-7EF7-4785-ABB8-F7AF66C0B161"/>
      <dmn:annotation name="annotation-1"/>
      <dmn:rule id="_8986B432-5E20-48D5-8DB8-2B0D1889F930">
        <dmn:inputEntry id="_1623F09B-169D-43D5-A663-502AADA39254">
          <dmn:text>&lt; 1000</dmn:text>
        </dmn:inputEntry>
        <dmn:inputEntry id="_A1F9CF5E-6FFA-466A-B6D9-EA94300797B7">
          <dmn:text>"NONE"</dmn:text>
        </dmn:inputEntry>
        <dmn:outputEntry id="_2AA5FABD-CD30-4531-8CBD-EC092B93AA03">
          <dmn:text>Price</dmn:text>
        </dmn:outputEntry>
        <dmn:annotationEntry>
          <dmn:text/>
        </dmn:annotationEntry>
      </dmn:rule>
      <dmn:rule id="_9A28ABA1-39EA-4F65-A6C8-CF58B9FB2AB0">
        <dmn:inputEntry id="_795519A9-819E-4F2B-99B7-E8F466AC0C64">
          <dmn:text>&lt; 1000</dmn:text>
        </dmn:inputEntry>
        <dmn:inputEntry id="_8E094135-554D-4C97-AA03-66A3671AF025">
          <dmn:text>"GOLD"</dmn:text>
        </dmn:inputEntry>
        <dmn:outputEntry id="_7BEEE2D8-8D7E-404F-93FA-78427B4D3905">
          <dmn:text>Price * 1.2</dmn:text>
        </dmn:outputEntry>
        <dmn:annotationEntry>
          <dmn:text/>
        </dmn:annotationEntry>
      </dmn:rule>
      <dmn:rule id="_868F6C30-FD4F-4174-81A0-80CC8F4B94D4">
        <dmn:inputEntry id="_1BFC1692-11AC-4E7E-A046-53A3A60CC0DC">
          <dmn:text>&gt;= 1000</dmn:text>
        </dmn:inputEntry>
        <dmn:inputEntry id="_230C9E92-E11A-4239-B3B0-07F8ABEC582E">
          <dmn:text>"GOLD"</dmn:text>
        </dmn:inputEntry>
        <dmn:outputEntry id="_57160E91-4F88-41D1-BBF2-1CD5E44A0A8F">
          <dmn:text>Price * 1.5</dmn:text>
        </dmn:outputEntry>
        <dmn:annotationEntry>
          <dmn:text/>
        </dmn:annotationEntry>
      </dmn:rule>
    </dmn:decisionTable>
  </dmn:decision>
  <dmndi:DMNDI>
    <dmndi:DMNDiagram>
      <di:extension>
        <kie:ComponentsWidthsExtension>
          <kie:ComponentWidths dmnElementRef="_CEDBBDEC-1DC2-4BD5-B081-3E5CCEF006AD">
            <kie:width>50</kie:width>
            <kie:width>100</kie:width>
            <kie:width>100</kie:width>
            <kie:width>100</kie:width>
            <kie:width>100</kie:width>
          </kie:ComponentWidths>
        </kie:ComponentsWidthsExtension>
      </di:extension>
      <dmndi:DMNShape id="dmnshape-_2DC3D0D9-7095-4937-A984-05644ABF651E" dmnElementRef="_2DC3D0D9-7095-4937-A984-05644ABF651E" isCollapsed="false">
        <dmndi:DMNStyle>
          <dmndi:FillColor red="255" green="255" blue="255"/>
          <dmndi:StrokeColor red="0" green="0" blue="0"/>
          <dmndi:FontColor red="0" green="0" blue="0"/>
        </dmndi:DMNStyle>
        <dc:Bounds x="220" y="235" width="100" height="50"/>
        <dmndi:DMNLabel/>
      </dmndi:DMNShape>
      <dmndi:DMNShape id="dmnshape-_CFC11C0F-61ED-4894-9A91-C00323ECA034" dmnElementRef="_CFC11C0F-61ED-4894-9A91-C00323ECA034" isCollapsed="false">
        <dmndi:DMNStyle>
          <dmndi:FillColor red="255" green="255" blue="255"/>
          <dmndi:StrokeColor red="0" green="0" blue="0"/>
          <dmndi:FontColor red="0" green="0" blue="0"/>
        </dmndi:DMNStyle>
        <dc:Bounds x="405" y="235" width="100" height="50"/>
        <dmndi:DMNLabel/>
      </dmndi:DMNShape>
      <dmndi:DMNShape id="dmnshape-_0F5C7423-AF66-41E8-ACF3-7DCF0CFC3A12" dmnElementRef="_0F5C7423-AF66-41E8-ACF3-7DCF0CFC3A12" isCollapsed="false">
        <dmndi:DMNStyle>
          <dmndi:FillColor red="255" green="255" blue="255"/>
          <dmndi:StrokeColor red="0" green="0" blue="0"/>
          <dmndi:FontColor red="0" green="0" blue="0"/>
        </dmndi:DMNStyle>
        <dc:Bounds x="313" y="97" width="100" height="50"/>
        <dmndi:DMNLabel/>
      </dmndi:DMNShape>
      <dmndi:DMNEdge id="dmnedge-_6352EB77-B695-4870-974A-141E8EC8FD59" dmnElementRef="_6352EB77-B695-4870-974A-141E8EC8FD59">
        <di:waypoint x="270" y="260"/>
        <di:waypoint x="363" y="147"/>
      </dmndi:DMNEdge>
      <dmndi:DMNEdge id="dmnedge-_81ACBB53-5BB7-4A6E-9788-506669E2633B" dmnElementRef="_81ACBB53-5BB7-4A6E-9788-506669E2633B">
        <di:waypoint x="455" y="260"/>
        <di:waypoint x="363" y="122"/>
      </dmndi:DMNEdge>
    </dmndi:DMNDiagram>
  </dmndi:DMNDI>
</dmn:definitions>
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
