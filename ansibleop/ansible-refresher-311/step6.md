If the playbook executes successfully, SSH to host01 and check if the file is created:
Use the below command to login to our target host

`ssh cent@host01`{{execute}}

List the files in the current directory by running the 'ls' command:

`ls`{{execute}}

Check if the file is populated with the name of the employee:

`cat names`{{execute}}

Exit out of the current ssh session and back to the Ansible host

`exit`{{execute}}
