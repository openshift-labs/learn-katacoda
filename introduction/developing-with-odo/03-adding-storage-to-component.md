Our `backend` application maintains a counter of requests. To make that data persistent between iterations, restarts, and migrations of the backend pods, we attach a bit of the cluster's available persistent storage pool to the `backend` component. `Odo` has a command to make this a one-step operation. It only needs to know the component requesting storage, where that storage should be mounted in the container file system, and the desired size of the storage request.

`odo storage create backend --path=/data --size=1G`{{execute}}
