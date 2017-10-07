The goal of this exercise is to gain a basic understanding of storage. Using "docker inspect" you can find the layers used in a particular container by looking at the GraphDriver -> Data.

``docker inspect openshift3/ose-pod:v3.4.1.10 | grep GraphDriver -A 7``


Optional Homework: With device mapper, which is the default configuration in RHEL7 and Atomic Host

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

Run the following command, but replace it with a volume from your live machine:

``dmsetup status docker-253:0-1402402-db523524bfa345fd768dfc1f89dadb01de3e424903470030ff4bd4b1a61e70d5``

Output:

``0 20971520 thin 1391616 20971519``


- 0 is starting point
- 20971520 (10GB) is length
- This is a 10G thin volume``
