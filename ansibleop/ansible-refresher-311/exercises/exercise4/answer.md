<pre class="file"
 data-filename="./playbook.yml"
  data-target="replace">
-
  name: Create a new file named names in the current directory
  hosts: localhost
  tasks:
    -
      name: Create a new file named names in the current directory
      command: touch names

    -
      name: Add name into names file
      shell: echo "Joe" > names

</pre>
