This project has already a `VehicleGenerator` class that will be used to send events to Kafka. However, is missing the Reactive Messaging code.

### Writing Kafka Records

The Kafka Connector can write Reactive Messaging Messages as Kafka Records.

In the application we will be sending the events to the `uber` channel through the following method:

<pre class="file" data-filename="./src/main/resources/application.properties" data-target="append" data-marker="//TODO-publisher">
    @Outgoing("uber")
    public Flowable<KafkaRecord<String, String>> generateUber()
    {
        return Flowable.interval(5000, TimeUnit.MILLISECONDS)
                .map(tick -> {
                    VehicleInfo vehicle = randomVehicle("uber");
                    LOG.info("dispatching vehicle: {}", vehicle);
                    return KafkaRecord.of(String.valueOf(vehicle.getVehicleId()), Json.encode(vehicle));
                });
    }
</pre>
This simple method:

- Instructs Reactive Messaging to dispatch the items from returned stream to the `uber`channel.
- Returns an [RX Java 2 stream](https://github.com/ReactiveX/RxJava) (`Flowable`) emitting a random  vehicle information every 5 seconds

The method returns a Reactive Stream. 