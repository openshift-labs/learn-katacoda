In Ansible, the inventory represents the machines that Ansible will manage.  Without an inventory, you would have a set of playbooks that define your desired system state, but wouldn’t know which machines you needed to run them against.

By default, Ansible will read `/etc/ansible/hosts` as its default inventory file. But you should maintain a different inventory file for each project that you have and pass it to both the `ansible` and `ansible-playbook` commands using the `–i` option.

Here is an example of passing a custom inventory file to `ansible` before running the `ping` module:

```
ansible all –i /path/to/inventory –m ping
```

In this tutorial you have access to one host named `host01`. To let Ansible know about it, put its hostname in an *inventory* file.

1\. We'll call our inventory file `myhosts`, and you'll add one group called `group1`:

`echo "[group1]" > myhosts`{{execute}}

2\. Then, add the host to the group, while also passing the username to use for SSH access, as an inventory parameter.

`echo "host01 ansible_ssh_user=cent" >> myhosts`{{execute}}

3\. You can use your terminal to verify that `myhosts` has been created: `cat myhosts`{{execute}}

4\. You can also run the following command to verify that your inventory is working properly:

`ansible all -i myhosts -m ping`{{execute}}

The response should look be:
```
host01 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

So, now that we have confirmed Ansible is properly configured, let's look at Ansible Playbooks.
