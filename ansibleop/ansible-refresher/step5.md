We have been running all tasks on localhost. We would now like to run these tasks on the host01.
Update the play to run the tasks on host01.

Once done, run the playbook:

`ansible-playbook playbook.yml`{{execute}}

Now if you are seeing the message skipping: no hosts matched, that's because you haven't specified the inventory file.

Use the inventory file we created in Step 1, `myhosts`, and run the playbook:

`ansible-playbook -i myhosts playbook.yml`{{execute}}
