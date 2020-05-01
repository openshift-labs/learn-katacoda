Since you are interested in *using Ansible for lifecycle management of applications on Kubernetes*, it will be beneficial to learn how to use the [Ansible k8s (Kubernetes) module](https://docs.ansible.com/ansible/2.6/modules/k8s_module.html). 

The k8s module allows you to:
 - Leverage your existing Kubernetes resource files (written in YAML) 
 - Express Kubernetes lifecycle management actions in native Ansible.

One of the biggest benefits of using Ansible in conjunction with existing Kubernetes resource files is the ability to use Ansible's built-in [Jinja templating](https://docs.ansible.com/ansible/latest/user_guide/playbooks_templating.html) engine to customize deployments by simply setting Ansible variables.

---

By the end of this scenario, you'll be able to use the Ansible k8s module to:

- _Create_ and _remove_ Kubernetes resources
- _Reuse_ existing Kubernetes manifest files with Ansible
