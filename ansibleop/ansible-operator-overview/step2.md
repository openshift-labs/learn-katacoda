Now that we have demonstrated the Ansible k8s modules, we want to trigger this Ansible logic when a *Custom Resource* changes. The Ansible Operator uses a Watches file (`watches.yaml`), written in YAML, which holds the mapping between Custom Resources and Ansible Roles/Playbooks.

**NOTE**: It is incredibly important that the Ansible Roles/Playbooks packaged into an Ansible Operator are **_[idempotent](https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html#term-idempotency)_**, as these tasks will be executed frequently to ensure the application is in its proper state.

## Structure of a *Watches file*

The **Watches file** contains a list of mappings from Custom Resources, identified by it's Group, Version, and Kind (GVK), to an Ansible Role or Playbook. The Operator expects this mapping file in a predefined location: `/opt/ansible/watches.yaml`

Each listing within the mapping file has mandatory fields:

* **group**: The group of the Custom Resource that you will be watching.

* **version**: The version of the Custom Resource that you will be watching.

* **kind**: The kind of the Custom Resource that you will be watching.

* **role** (default): This is the path to the role that you have added to the container. For example if your roles directory is at `/opt/ansible/roles/` and your role is named `busybox`, this value will be `/opt/ansible/roles/busybox`. This field is mutually exclusive with the "playbook" field.

* **playbook**: This is the path to the Playbook that you have added to the container. This Playbook is expected to be simply a way to call Roles. This field is mutually exclusive with the "role" field.

## Sample *watches.yaml*

```yaml
---
- version: v1alpha1
  group: foo.example.com
  kind: Foo
  # associating a Custom Resource GVK with a Role
  role: /opt/ansible/roles/Foo
```

By default, `operator-sdk new --type ansible <project-name>` creates `watches.yaml` configured to *execute a role* in response to a *Custom Resource* event. 

This works well for smaller projects, but for more complex  Ansible code we might not want all of our logic in a single role. 

## Triggering a Playbook instead of a Role

Configuring the *Watches file* to run a Playbook allows the developer more flexibility in consuming other Ansible roles and enabling more customized application deployments. 

To use a Playbook in your operator, you would modify `watches.yaml` as shown below:

```yaml
---
- version: v1alpha1
  group: foo.example.com
  kind: Foo
  # associating a Custom Resource GVK with a Playbook
  playbook: /opt/ansible/playbook.yaml
```

Before this will fully work, we need to copy `playbook.yaml` into the container image.

You would accomplish this by modifying `<project-name>/build/Dockerfile` to *COPY* `playbook.yaml` into the container as shown below:

```
FROM quay.io/water-hole/ansible-operator

COPY roles/ ${HOME}/roles
COPY watches.yaml ${HOME}/watches.yaml

# New 'COPY' build step for playbook.yaml
COPY playbook.yaml ${HOME}/playbook.yaml
```

## Generating a project skeleton preconfigured to use a Playbook

If you know from the start that you want to use a Playbook instead of a Role, you can generate a skeleton project with a playbook preconfigured:

`operator-sdk new --type ansible --kind Foo --api-version foo.example.com/v1alpha1 foo-operator --generate-playbook --skip-git-init`
