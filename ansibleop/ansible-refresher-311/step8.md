We can now consume this role inside of playbook.yaml instead of declaring the tasks inside of our playbook. Modify our existing playbook.yaml to reference our newly created role.

Once updated run the ansible-playbook again using the below command:

`ansible-playbook playbook.yml`{{execute}}

Once the execution is complete, view the contents of the file to ensure the name was added.

`cat names`{{execute}}
