The application will now generate a new event with vehicle information every 5 seconds.

### Wait for the application deployment

The deployment will start the application pods. You can monitor the pods with the following command:

``oc get pods -l deploymentconfig=kafka-quarkus -w``{{execute}}

You will see the pod changing the status to `running`:

```sh
NAME                    READY   STATUS    RESTARTS   AGE
kafka-quarkus-1-mg8cv   0/1     Pending   0          0s
kafka-quarkus-1-mg8cv   0/1     Pending   0          0s
kafka-quarkus-1-mg8cv   0/1     ContainerCreating   0          0s
kafka-quarkus-1-mg8cv   0/1     ContainerCreating   0          2s
kafka-quarkus-1-mg8cv   0/1     ContainerCreating   0          8s
kafka-quarkus-1-mg8cv   1/1     Running             0          13s
```

Press <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the process.

`^C`{{execute ctrl-seq}}

# Check the application log

To verify there was no problem with the application, we can check the logs with the following command:

``oc logs dc/kafka-quarkus -f``{{execute interrupt}}

You should see the information of the Quarkus application connecting to Kafka as well as the output of the sent events:

```sh
...
INFO [io.quarkus] (main) kafka-quarkus 1.0.0 on JVM (powered by Quarkus 1.10.3.Final) started in 2.394s. Listening on: http://0.0.0.0:8080
INFO [io.quarkus] (main) Profile prod activated.
INFO [io.quarkus] (main) Installed features: [cdi, kubernetes, mutiny, smallrye-context-propagation, smallrye-reactive-messaging, smallrye-reactive-messaging-kafka, vertx]
INFO [com.red.kat.kaf.VehicleGenerator] (RxComputationThreadPool-1) dispatching vehicle: VehicleInfo{provider='uber', vehicleId=1, pricePerMinute=9.633610913249816, timeToPickup=4, availableSpace=2, available=true}
WARN [org.apa.kaf.cli.NetworkClient] (kafka-producer-network-thread | kafka-producer-uber) [Producer clientId=kafka-producer-uber] Error while fetching metadata with correlation id 3 : {uber=LEADER_NOT_AVAILABLE}
WARN [org.apa.kaf.cli.NetworkClient] (kafka-producer-network-thread | kafka-producer-uber) [Producer clientId=kafka-producer-uber] Error while fetching metadata with correlation id 4 : {uber=LEADER_NOT_AVAILABLE}
WARN [org.apa.kaf.cli.NetworkClient] (kafka-producer-network-thread | kafka-producer-uber) [Producer clientId=kafka-producer-uber] Error while fetching metadata with correlation id 5 : {uber=LEADER_NOT_AVAILABLE}
INFO [com.red.kat.kaf.VehicleGenerator] (RxComputationThreadPool-1) dispatching vehicle: VehicleInfo{provider='uber', vehicleId=2, pricePerMinute=4.502112907514153, timeToPickup=15, availableSpace=5, available=true}
```

Then you will see new events every few seconds.

Press <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the process.

`^C`{{execute ctrl-seq}}

### Check the Kafka records

Now, let see how the messages look within Kafka.

Check the messages with this command:

``oc exec -c kafka my-cluster-kafka-0 -- /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic uber --from-beginning | jq``{{execute interrupt}}

The output presents like this:

```json
...
{
  "vehicleId": 93,
  "pricePerMinute": 9.57522356183256,
  "timeToPickup": 15,
  "availableSpace": 3,
  "available": true
}
{
  "vehicleId": 94,
  "pricePerMinute": 7.255313141956367,
  "timeToPickup": 21,
  "availableSpace": 8,
  "available": true
}
```

Press <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the process.

`^C`{{execute ctrl-seq}}

Congratulations! You are now sending events to Kafka using the Quarkus Reactive Messaging extension for Kafka.
