Our rule will contain a single *Action* column. This column basically sets the `approved` boolean field of the `LoanApplication` fact to `true` or `false`. I.e. the action of the rule is to define whether the loan application has been approved.

1. Click again on *New Column*
2. Select *Set the value of a field*
3. Provide the following values:
- Fact: `l` (this is our Loan fact that we defined in our Condition columns)
- Field: `approved`
- Column header: `Approved?`
4. Save the Decision Table.

We can now implement the rows of our decision table which in fact defines our rules, where each row defines a single rule.
