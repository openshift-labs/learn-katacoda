Time to check that the deployment is working, and the Topic Operator successfully created the topic.

### Accessing the running Kafka broker pod

AMQ streams provides container images with the Apache Kafka distribution, including console scripts. Let's connect to the running broker to execute those scripts.

Support for remote container command execution is built into the `oc` CLI. `Bash` is one of the commands we can execute. To get an interactive terminal issue the following command:

`oc exec -it my-cluster-kafka-0 -- bash`{{execute}}

You are now running a terminal into the Kafka broker container. Here you can execute the scripts available in the `/bin` directory.

### Reviewing topic information

Use the `kafka-topics` shell script as a command line tool that can alter, create, delete and list topic information from a Kafka cluster.

Let's use it to describe the `my-topic` we asked the Topic Operator to create for us in the previous step:

`bin/kafka-topics.sh --bootstrap-server localhost:9092 --describe`{{execute}}

> We are using localhost:9092 as we are running within the same container.

You will get output similar to this:

```
OpenJDK 64-Bit Server VM warning: If the number of processors is expected to increase from one, then you should configure the number of parallel GC threads appropriately using -XX:ParallelGCThreads=N
Topic: my-topic PartitionCount: 1       ReplicationFactor: 1    Configs:
        Topic: my-topic Partition: 0    Leader: 0       Replicas: 0     Isr: 0
```

> The `my-topic` topic has 1 partition and a replication factor of 1 as defined in the KafkaTopic resouce.

Time to send and receive events!
