We can now create our first rules project. A JBoss BRMS rules project can contain various types of rule assets:

1. DRL: Rule definitions written in the *Drools Rule Language*
2. Guided Rules: rules written in a more business friendly language, including a business friendly editor
3. Guided Decision Tables: rules written in the form of a decision table.
4. etc.

To create the project, perform the following steps:
1. First, make sure to select the "loan" repository in the breadcrumbs right under the text *Project Explorer*.

<img src="../../assets/middleware/brms-loan-application/brms-select-loan-repository.png" width="400" />

Now that we've selected the correct repository, we can create our project.

1. Click on *Authoring -> Project Authoring*
2. Click on *New Item -> Project*
3. Provide the following details:
- Project Name: `loandemo`{{copy}}
- Group ID: `com.redhat.demos`{{copy}}
- Artifact ID: `loandemo`{{copy}}
- Version: `1.0`{{copy}}
4. Click on the *Finish* button

We've now created our first BRMS project and can now start creating rules assets. We will begin with creating our domain-model.
