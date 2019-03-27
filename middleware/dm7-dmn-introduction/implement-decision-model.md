With the DMN file created, and the various DRD elements explained we can start creating our model.

Our model will define some basic decision logic to calculate an __insurance premium__ for a car insurance based on 2 data inputs:
- `Age` (Number): the age of the driver.
- `Had previous incidents` (boolean): whether the driver has had previous incidents or not.

To model the 2 data inputs, we add 2 DMN `Input Data` nodes to our model. We name one node `Age`{{copy}} and the other `Had previous incidents`{{copy}}. Your diagram will look like this:

<img src="../../assets/middleware/dm7-dmn-introduction/dmn-model-input-data
.png" width="300"/>

DMN defines various out-of-the-box datatypes that we can use in our models. To define the datatype of the `Age` Input Data node, click on the node and open its properties by clicking on the pencil icon in the upper right corner of the editor. In the properties panel, set the "Output data type" to `number`:

<img src="../../assets/middleware/dm7-dmn-introduction/dmn-input-data-properties.png" width="450"/>

Set the "Output data type" of `Had previous incidents` to `boolean`. Save the model by clicking on the _Save_ button at the top of the editor.

Next, we want to define our _Decision Node_. Input data can either come from an _Input Data_ node, or can be the result (or output) of another _Decision Node_. In DMN, the output of a _Decision Node_ is always a value (in contrast to, for example, Drools DRL rules, that can take actions as a result of a decision).

In this tutorial, the decision node is responsible for determining the premium of the insurance based on the data coming from our 2 input data nodes.

1. Create a new Decision Node in your DRD. Name it "Insurance Premium".
2. Connect the 2 Input Data nodes to the new Decision Node.
3. Click on the Decision Node and open the properties panel (again by clicking on the pencil icon on the right side of the screen). Set the "Output data type" of the `Insurance Premium` decision node to `number`.
4. Save the model.

Your complete DRD should look like this:

<img src="../../assets/middleware/dm7-dmn-introduction/dmn-model-complete.png" width="450"/>

Before we continue to the next step, we need to write 2 values down, as these values are required later in this tutorial when we want to test our model. To be able to test our model, we need to know both the _namespace_ and the _name_ of our DMN model. These values can be found in the properties of the DRD. In the DMN Designer, click anywhere in the model, except for any of the nodes or arrows. This will select the DMN model as a whole. In the properties panel, you can now see both the `Name` and `Namespace` of the model. Copy paste both of these values, as we will need them later in this scenario:

<img src="../../assets/middleware/dm7-dmn-introduction/dmn-model-properties.png" width="450"/>

In the next step we will implement the decision logic of the Decision Node.
