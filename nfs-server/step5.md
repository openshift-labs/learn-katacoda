Our Pods can now read/write. MySQL will store all database changes to the NFS Server while the HTTP Server will serve static from the NFS drive. When upgrading, restarting or moving containers to a different machine the data will still be accessible.

To test the HTTP server, write a 'Hello World' _index.html_ homepage. In this scenario, we know the HTTP directory will be based on _data-0001_ as the volume definition hasn't driven enough space to satisfy the MySQL size requirement.

`docker exec -it nfs-server bash -c "echo 'Hello World' > /exports/data-0001/index.html"`{{execute}}

Based on the IP of the Pod, when accessing the Pod, it should return the expected response.

`ip=$(oc get pod www -o yaml |grep podIP | awk '{split($0,a,":"); print a[2]}'); echo $ip`{{execute}}

`curl $ip`{{execute}}

## Update Data
When the data on the NFS share changes, then the Pod will read the newly updated data.

`docker exec -it nfs-server bash -c "echo 'Hello NFS World' > /exports/data-0001/index.html"`{{execute}}

`curl $ip`{{execute}}
