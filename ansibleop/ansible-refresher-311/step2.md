Playbooks are Ansible’s configuration, deployment, and orchestration language. Inside of playbooks a developer can declare a set of tasks or Ansible Roles to be executed on launching the playbook.

For simplicity, let's start with declaring the tasks directly in the playbook. Start by updating our `playbook.yaml` with a debug statement to output information from our host:


Copy following YAML to the playbook named **playbook.yml** which will execute a command on host01.

<pre class="file"
 data-filename="./playbook.yml"
  data-target="replace">
-
  name: Execute a command on localhost
  hosts: localhost
  tasks:
    -
      name: Create a new file on localhost
      command: touch names

</pre>

This playbook will run `touch command` to create a new file in the current directory.

Run the playbook with **ansible-playbook** command:

`ansible-playbook playbook.yml`{{execute}}

# Output.
You can verify that file named `names` was created by listing the contents of the current directory `ls`{{execute}}.
