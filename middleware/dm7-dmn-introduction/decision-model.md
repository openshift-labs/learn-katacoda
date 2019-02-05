The asset we will create is a DMN model. With the DMN Designer enabled, navigate back to the project we've created earlier. You can do this by clicking on "Menu -> Design -> Projects". This should bring you back to your `Space` (which is called 'MySpace').

<img src="../../assets/middleware/dm7-dmn-introduction/dm7-myspace.png" width="600"/>

Click on the 'dmn-decision-service' tile to open the project.

<img src="../../assets/middleware/dm7-dmn-introduction/dm7-empty-project.png" width="600"/>

The project is empty. We will now add our DMN model. Click on the `Add Asset` button in the center of the screen. In the filter on the upper left of the screen type `dmn` to filter the DMN assets":

<img src="../../assets/middleware/dm7-dmn-introduction/dm7-dmn-asset-filter.png" width="600"/>

Click on the `DMN (Preview)` tile to create a new DMN model:
  - Name: `insurance-premium`{{copy}}
  - Package: `com.myspace.dmn_decision_service` (this should be the default)

This will create a new DMN model and open the DMN editor.

A DMN DRD, or Decision Requirements Diagram, supports various modeling constructs. In the palette on the left side of the modeler, you can see 5 constructs:
- DMN Text Annotation: text used for comment or explanation.
- DMN Input Data:  the inputs of a decision whose values are defined outside of the decision
model.
- DMN Knowledge Source: used to model authoritative knowledge sources in a decision model.
- DMN Business Knowledge Model:
- DMN Decision

In this introduction we will use the DMN `Input Data`, `Decision` and `Text Annotation` nodes.
