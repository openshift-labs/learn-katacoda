Time to check that the deployment is working and that the operator successfully created the topic.

### Access the running Kafka broker pod

AMQ streams provide container images wit the Apache Kafka distribution including the console scritps. Let's connect to the running broker to execute those scritps.

Support for remote container command execution is built into the CLI. `Bash` is one of the commands we can execute. To get an interactive terminal issue the following command:

`oc exec -it my-cluster-kafka-0 -- bash`{{execute}}

You are now running a terminal into the Kafka broker container. Here you can execute the scripts available in the `/bin` directory.

### Review the topic information

Use the `kafka-topics` shell script is a command line tool that can alter, create, delete and list topic information from a kafka cluster.

Let's use it to describe the `my-topic` we asked the operator to create for us in the previous step:

`bin/kafka-topics.sh --bootstrap-server localhost:9092 --describe`{{execute}}

> We are using localhost:9092 as we are running within the same container.

You should get an output similar to this:

```
OpenJDK 64-Bit Server VM warning: If the number of processors is expected to increase from one, then you should configure the number of parallel GC threads appropriately using -XX:ParallelGCThreads=N
Topic: my-topic PartitionCount: 1       ReplicationFactor: 1    Configs:
        Topic: my-topic Partition: 0    Leader: 0       Replicas: 0     Isr: 0
```

> The `my-topic` topic has 1 partition and a replication factor of 1 as we defined in the KafkaTopic resouce.

Time to send and receive events!
