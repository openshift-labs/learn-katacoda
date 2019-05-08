The goal of this exercise is to gain a basic understanding of storage. 

First, lets take a look at which Graph Driver is used by the Docker daemon:

`podman info | grep GraphDriverName`{{execute}}


Now, for troubleshooting purposes, imagine that we want to see which volume of storage is used by the haproxy container. Using "docker inspect" you can find the layers used in a particular container by looking at the GraphDriver -> Data.

``docker inspect $(docker ps | grep haproxy | cut -d" " -f1) | grep GraphDriver -A7``{{execute}}


Device Mapper is the default storage configuration for RHEL7 and Atomic Host. You can use the dmsetup command to find out storage information for all the running containers with the following command: 

``dmsetup ls --tree -o inverted``{{execute}}


`` (252:17)
 └─rhel-docker--pool_tdata (253:2)
    └─rhel-docker--pool (253:3)
       ├─docker-253:0-1402402-f70a1cebec4167011928bd416433cb8a88de3fe3c4cc2be3ab2aeab037493e94 (253:5)
       ├─docker-253:0-1402402-d84266b8f40669145a81d8d65129da46377b5638e529c57f2c34b53d209b1c67 (253:4)
       ├─docker-253:0-1402402-44b7ce3570b098fecf5d5435407d365ec854ece6eb8c7e2cd95cde69b85aa20d (253:7)
       └─docker-253:0-1402402-db523524bfa345fd768dfc1f89dadb01de3e424903470030ff4bd4b1a61e70d5 (253:6)
 (252:2)
 ├─rhel-docker--pool_tmeta (253:1)
 │  └─rhel-docker--pool (253:3)
 │     ├─docker-253:0-1402402-f70a1cebec4167011928bd416433cb8a88de3fe3c4cc2be3ab2aeab037493e94 (253:5)
 │     ├─docker-253:0-1402402-d84266b8f40669145a81d8d65129da46377b5638e529c57f2c34b53d209b1c67 (253:4)
 │     ├─docker-253:0-1402402-44b7ce3570b098fecf5d5435407d365ec854ece6eb8c7e2cd95cde69b85aa20d (253:7)
 │     └─docker-253:0-1402402-db523524bfa345fd768dfc1f89dadb01de3e424903470030ff4bd4b1a61e70d5 (253:6)
 └─rhel-root (253:0)``

Now, lets find out exactly which blocks this container is using on disk. Run the output from the below code. You can use the environment variables to better understand its construction:

``export HAPROXY_CONTAINER=$(docker ps | grep haproxy | cut -d" " -f1)
export DEVICEMAPPER_VOLUME=$(docker inspect $HAPROXY_CONTAINER | grep GraphDriver -A7 | grep DeviceName | cut -d\" -f4)
echo "dmsetup status $DEVICEMAPPER_VOLUME"
``{{execute}}


Or, for those of you who like compact Bash one-liners:

``dmsetup status $(docker inspect $(docker ps | grep haproxy | cut -d" " -f1) | grep GraphDriver -A7 | grep DeviceName | cut -d\" -f4)``{{execute}}

Output:

``0 20971520 thin 1391616 20971519``

The output is poorly document, but here is what it means:

- 0 is starting point
- 20971520 (10GB) is length
- This is a 10G thin volume``
