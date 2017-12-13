We can now implement our rules, we will write 4 rules in total that, depending on your creditscore and the requested amount, will decide whether the loan will be approved or not.

These are our 4 rules:

| Description | Minimum Credit Score | Maximum Credit Score | Minimum Amount | Maximum Amount | Approved? |
| ----------- |:--------------------:|:--------------------:|:--------------:|:--------------:|:---------:|
| Rule 1      |                      |         200          |        0       |                |   false   |
| Rule 2      |         201          |         400          |                |      4000      |    true   |
| Rule 3      |         201          |         400          |      4001      |      5000      |    false  |
| Rule 4      |         401          |                      |                |      5000      |    true   |

The final table will look like this:

<img src="../../assets/middleware/brms-loan-application/brms-decision-table.png" width="800" />
