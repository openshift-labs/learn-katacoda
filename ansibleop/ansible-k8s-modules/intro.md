Since we are interested in using Ansible for the lifecycle management of our application on Kubernetes, it is beneficial for a developer to get a good grasp of the [k8s Ansible module](https://docs.ansible.com/ansible/2.6/modules/k8s_module.html). This Ansible module allows a developer to either leverage their existing Kubernetes resource files (written in YaML) or express the lifecycle management in native Ansible. One of the biggest benefits of using Ansible in conjunction with existing Kubernetes resource files is the ability to use Jinja templating so that you can customize deployments with the simplicity of a few variables in Ansible.

By the end of this module, you will understand:

* How to create and remove resources in Kubernetes
* How to reuse an existing Kubernetes manifest file with Ansible
