Ansible Roles are great because they allow a developer to declare all variables along with defaults ahead of time to ensure idempotence regardless of how the role is executed. As a simple example, let's declare a variable `names` which we will write to the employees file during execution of our Role. Let's declare a default message by editing `example-role/defaults/main.yml`:

<pre class="file"
 data-filename="./example-role/defaults/main.yml"
  data-target="replace">
---
names:
  - John Smith
  - Tom Jones
  - Lisa Kelly

  </pre>

  Now modify example-role/tasks/main.yml to write the names to the newly created file:

  <pre class="file"
   data-filename="./example-role/tasks/main.yml"
    data-target="replace">
-
  name: Create a new file on localhost
  command: touch names
-
  name: Add names into names file
  shell: echo {{names}} > names

  </pre>

  Once updated run the ansible-playbook again using the below command:

  `ansible-playbook playbook.yml`{{execute}}

  Once the execution is complete, view the contents of the file to ensure the employees names were added.

  `cat names`{{execute}}

  We can also overwrite the default message by passing along message as an extra var when launching the playbook:

  `ansible-playbook playbook.yml -e 'names="Steve Stevens"'`{{execute}}
