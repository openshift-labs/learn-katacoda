Condition columns in our decision table will define the so called *Left-Hand-Side* (LHS) of our rules, also know as the *when* part of a rule. When these constraints are met, the rule will fire and will execute the action defined in the *Right-Hand-Side* or *then* part of the rule.

Our decision table will consist of 4 *Condition* columns and one *Action* column. In this chapter we will define the constraint columns.

To add a *Condition* column:

1. Click on the *+* sign next to the word *Decision Table*
2. Click on *New Column*
3. Select `Add a Simple Condition` and define the following settings:
- Pattern: `Applicant`: (set `a` for binding)
- Calculation Type: `Literal Value`
- Field: `creditScore`
- Operator: `greater than or equal to`
- Column Header: `Minimum Credit Score`

Define 3 additional Condition columns with the following values:

1. Pattern: `Applicant` (set `a` for binding)
2. Calculation Type: `Literal Value`
3. Field: `creditScore`
4. Operator: `less than or equal to`
5. Column Header: `Maximum Credit Score`


1. Pattern: `Loan` (set `l` for binding)
2. Calculation Type: `Literal Value`
3. Field: `amount`
4. Operator: `greater than or equal to`
5. Column Header: `Minimum Amount`


1. Pattern: `Loan` (set `l` for binding)
2. Calculation Type: `Literal Value`
3. Field: `amount`
4. Operator: `less than or equal to`
5. Column Header: `Maximum Amount`

Now that the *Condition* columns have been defined, we can work on the *Action* column.
