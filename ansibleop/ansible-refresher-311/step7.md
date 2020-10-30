At a basic level, Playbooks can be used to manage configurations and deployments to remote machines. However, putting all of our orchestration logic inside of a single playbook file can be cumbersome, which is why it is recommended to separate our logic into multiple Ansible Roles. Let's move our tasks inside of a role.

Ansible Roles are a way of grouping related tasks and other data together in a known file structure. Grouping content by roles allows it to easily be shared with others. Roles are easier to reuse than playbooks.

Now that we have seen how tasks are executed inside of playbooks, let's move the same logic inside of an Ansible Role. Begin by creating a new role using `ansible-galaxy`:  *Note: We will use the --offline option so we do not query the galaxy API*

`ansible-galaxy init example-role --offline`{{execute}}

This generates a skeleton Role which can be easily modified by editing the tasks inside of `example-role/tasks/main.yml`. For a simple example, let's modify the tasks file to print out information about our host as we did in the previous example:

<pre class="file"
 data-filename="./employee-role/tasks/main.yml"
  data-target="replace">
  -
    name: Create a new file on localhost
    command: touch names
  -
    name: Add name into names file
    shell: echo "Joe" > names

</pre>

Now that we have created a role, let's look at how to consume this in our playbook.
