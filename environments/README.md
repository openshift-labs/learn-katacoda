# Environments

## Modifying

The Packer `json` files define which scripts to run to configure the base environments.

For example, to modify the installation of OpenShift Middleware, edit the script `openshift-middleware/scripts/middleware.sh`.

### Building Locally

_Depending on hardware, builds may take over 30mins to complete. This functionality might replaced in future with a better approach._

### Packer

Install Packer from https://www.packer.io/downloads.html

### Build CentOS

This is the base OS used for the OpenShift installation.

```
cd environments/centos
curl -LO https://buildlogs.centos.org/rolling/7/isos/x86_64/CentOS-7-x86_64-NetInstall-1611.iso
packer build packer.json
```

### Build OpenShift Image

This build extends the CentOS Image with Openshift Installation
```
cd environments/openshift
packer build openshift.json
```

### Build OpenShift Middleware Image

This build extends the OpenShift Image with additional configuration and cached images.

```
cd environments/openshift-middleware
packer build openshift-middleware.json
```

### Packer Documentation

https://www.packer.io/docs/builders/qemu.html
