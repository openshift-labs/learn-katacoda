Our `backend` application maintains a counter of requests. To make that counter live through iterations, restarts, and migrations of `backend` pods, we attach persistent storage to the `backend` component. A storage pool is already configured on our cluster, so the `odo storage` subcommand only needs to know the component requesting storage, where that storage should be mounted in the component's file system, and the desired size of the storage request:

`odo storage create backend --path=/data --size=1G`{{execute}}
