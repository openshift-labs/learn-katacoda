Let us now add a new task to the current playbook to add some contents into the file.

Add a new task to the playbook named **Add name into names file**.
This time instead of **command** let us use the **shell** module and the command **echo "Joe" > names**

> The **command** and **shell** modules are very similar. The shell module runs the command through a shell, however the command module does not execute a command through a shell.

Once updated run the ansible-playbook again using the below command:

`ansible-playbook playbook.yml`{{execute}}

Once the execution is complete, view the contents of the file to ensure the name was added.

`cat names`{{execute}}
