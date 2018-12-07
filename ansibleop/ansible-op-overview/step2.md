Now that we have demonstrated the Ansible k8s modules, we want to trigger this Ansible logic when a custom resource changes. The Ansible Operator uses a Watches file (`watches.yaml`), written in YAML, which holds the mapping between custom resources and Ansible Roles/Playbooks.

**NOTE**: It is incredibly important that the Ansible Roles/Playbooks which are executed are deemed idempotent by the developer as these tasks will be executed frequently to ensure the application is in its proper state.

The Watches file contains a list of mappings from custom resources, identified by it's Group, Version, and Kind, to an Ansible Role or Playbook. The Operator expects this mapping file in a predefined location: `/opt/ansible/watches.yaml`

Each listing has mandatory fields:

* **group**: The group of the Custom Resource that you will be watching.

* **version**: The version of the Custom Resource that you will be watching.

* **kind**: The kind of the Custom Resource that you will be watching.

* **role** (default): This is the path to the role that you have added to the container. For example if your roles directory is at `/opt/ansible/roles/` and your role is named `busybox`, this value will be `/opt/ansible/roles/busybox`. This field is mutually exclusive with the "playbook" field.

* **playbook**: This is the path to the playbook that you have added to the container. This playbook is expected to be simply a way to call roles. This field is mutually exclusive with the "role" field.

Example specifying a role:

```yaml
---
- version: v1alpha1
  group: foo.example.com
  kind: Foo
  role: /opt/ansible/roles/Foo
```

By default, `operator-sdk new --type ansible` sets `watches.yaml` to execute a role directly on a resource event. This works well for new projects, but with a lot of Ansible code this can be hard to scale if we are putting everything inside of one role. Using a playbook allows the developer to have more flexibility in consuming other roles and enabling more customized deployments of their application. To do this, modify `watches.yaml` to use a playbook instead of the role:

```yaml
---
- version: v1alpha1
  group: foo.example.com
  kind: Foo
  playbook: /opt/ansible/playbook.yaml
```

Modify `tmp/build/Dockerfile` to put `playbook.yaml` in `/opt/ansible` in the container in addition to the role (`/opt/ansible` is the `HOME` environment variable inside of the Ansible Operator base image):

```
FROM quay.io/water-hole/ansible-operator

COPY roles/ ${HOME}/roles
COPY playbook.yaml ${HOME}/playbook.yaml
COPY watches.yaml ${HOME}/watches.yaml
```

Alternatively, to generate a skeleton project with the above changes, a developer can also do:

`operator-sdk new --type ansible --kind Foo --api-version foo.example.com/v1alpha1 foo-operator --generate-playbook --skip-git-init`
