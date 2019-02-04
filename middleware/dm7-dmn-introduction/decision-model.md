The first asset we need to create is our data-model. The data-model defines the rule *facts* on which we will execute our rules.

A data-model in Decision Manager can have many forms. As Decision Manager is a Java-based rules engine, it operates on Java POJOs (Plain Old Java Objects). As such we can both re-use existing (corporate) data-models defined in external JARs (Java Archives), as well as define these POJOs in our rules project as assets. Red Hat Decision Manager provides a simple data modeling tool that allows business users to create their data-models without having to know the Java programming language.

We will create a simple data model consisting of 2 classes: *Applicant* and *Loan*.

1. Click on *Create New Asset -> Data Object* menu or on the *Data Object* button to create a new data object asset.
    <img src="../../assets/middleware/dm7-loan-application/dm7-add-data-object.png" width="600" />

2. Give the object the name `Applicant`{{copy}}
3. Click on *OK*

Give the object two fields:
1. Click on *+ add field*
2. Add the field with *Id* `name`{{copy}} and *Label* `Name`{{copy}} of type `String`
3. Click on *Create and Continue*
4. Add the field with *Id* `creditScore`{{copy}} and *Label* `Credit Score`{{copy}} of type `int`
5. Click on *Create*
6. Click on the *Save* button to save the model

<img src="../../assets/middleware/dm7-loan-application/dm7-datamodel-applicant.png" width="800" />

Go back to the project asset list by click on "loan-application" breadcrumb on the top of the screen.

Next, create a data object with name `Loan`{{copy}} with the following fields:

1. amount: int (Label: Amount)
2. duration: int (Label: Duration)
3. interestRate: double (Label: Interest Rate)
4. approved: boolean (Label: Approved)

Make sure to also save this model using the *Save* button in the editor.

<img src="../../assets/middleware/dm7-loan-application/dm7-datamodel-loan.png" width="800" />

Click on the "loan-application" breadcrumb on the top of the screen to go back to the project asset list. We can now create our rules.
