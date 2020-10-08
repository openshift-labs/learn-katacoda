***

*This step doesn't require changes to the interactive environment, but feel free to explore.*

***

Now that we have demonstrated the Ansible k8s modules, we want to trigger this Ansible logic when a *Custom Resource* changes. The Ansible Operator uses a *Watches file*, written in YAML, which holds the mapping between Custom Resources and Ansible Roles/Playbooks.

**NOTE**: It is incredibly important that the Ansible Roles/Playbooks packaged into an Ansible Operator are **[idempotent](https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html#term-idempotency)**, as these tasks will be executed frequently to ensure the application is in its proper state.

## Structure of a *Watches file*

The **Watches file** maps Custom Resources (identified by Group, Version, and Kind [GVK]) to Ansible Roles and Playbooks. The Operator expects this mapping file in a predefined location: `/opt/ansible/watches.yaml`

Each mapping within the Watches file has mandatory fields:

* **group**: Group of the Custom Resource that you will be watching.

* **version**: Version of the Custom Resource that you will be watching.

* **kind**: Kind of the Custom Resource that you will be watching.

* **role** (_default_): Path to the Role that should be run by the Operator for a particular Group-Version-Kind (GVK). This field is mutually exclusive with the "playbook" field.

* **playbook** (_optional_): Path to the Playbook that should be run by the Operator for a particular Group-Version-Kind (GVK). A Playbook can be used to invoke multiple Roles. This field is mutually exclusive with the "role" field.

__Sample watches.yaml__

```yaml
---
- version: v1alpha1
  group: foo.example.com
  kind: Foo
  # associates GVK with Role
  role: /opt/ansible/roles/Foo

```

By default, `operator-sdk new --type ansible` creates 'watches.yaml' configured to *execute a role* in response to a *Custom Resource* event. 

This works well for smaller projects, but for more complex Ansible we might not want all of our logic in a single role. 

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

For this to work, we would need to copy `playbook.yaml` into the container image.

You would accomplish this by modifying the Operator Dockerfile to *COPY* 'playbook.yaml' into the container as shown below:

```
# Dockerfile at <project-name>/build/Dockerfile

FROM quay.io/operator-framework/ansible-operator

COPY roles/ ${HOME}/roles
COPY watches.yaml ${HOME}/watches.yaml

# New 'COPY' build step for playbook.yaml
COPY playbook.yaml ${HOME}/playbook.yaml

```

## Preconfiguration for a Playbook

If you know from the start that you want your Operator to use a Playbook instead of a Role, you can generate your project scaffolding with the `--generate-playbook` flag:

```
operator-sdk new --type ansible --kind Foo --api-version foo.example.com/v1alpha1 foo-operator --generate-playbook --skip-git-init
```
