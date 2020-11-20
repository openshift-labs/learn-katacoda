Kafka clients conenct through the network to the Kafka brokers where the topic has some partitions to write and read events.

### Produce a few events

Similar to the previous step, we will use the producer shell script to write some events.

Run the console producer to send a message per line:

`bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic my-topic`{{execute}}

You will get a prompt to start sending the messages, try with hello world!

`hello world!`{{execute}}

Try some more lines and finally hit <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the process.

`^C`{{execute ctrl-seq}}

### Consume the events

Time to read the event that you wrote above

Run the console consumer shell script:

`bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic --from-beginning`{{execute interrupt}}

You should get the messages we wrote above. It should look similar to this:

```
OpenJDK 64-Bit Server VM warning: If the number of processors is expected to increase from one, then you should configure the number of parallel GC threads appropriately using -XX:ParallelGCThreads=N
hello world!
```

Hit <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the process.

`^C`{{execute ctrl-seq}}

### Congratulations

You successfully completed this scenario! You know now how to deploy a simple Apache Kafka cluster on top of OpenShift using the Red Hat Integration AMQ streams operator.
