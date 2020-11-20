The last step to do is to create a link between Debezium and a source MySQL database.

As we mentioned in the previous step, we can interact with the Connect node using AMQ streams custom resources.

### Create a KafkaConnector

To register the source we need to create a KafkaConnector resource.An example registration resource is part of the evironment - `kafka-connector.yaml`{{open}}.

To register the database source execute the following command:

``oc -n debezium apply -f /root/projects/debezium/kafka-connector.yaml``{{execute interrupt}}

Check the Connect's log file to see that the registration has succeeded and change data capture has started:

``oc logs -f deploy/debezium-connect``{{execute}}

You should see an output similar to the this:

```bash
...
2020-11-19 22:44:19,632 INFO Transitioning from the snapshot reader to the binlog reader (io.debezium.connector.mysql.ChainedReader) [task-thread-debezium-connector-0]
2020-11-19 22:44:19,662 INFO Creating thread debezium-mysqlconnector-dbserver-mysql-binlog-client (io.debezium.util.Threads) [task-thread-debezium-connector-0]
2020-11-19 22:44:19,667 INFO Creating thread debezium-mysqlconnector-dbserver-mysql-binlog-client (io.debezium.util.Threads) [blc-mysql.default.svc:3306]
Nov 19, 2020 10:44:19 PM com.github.shyiko.mysql.binlog.BinaryLogClient connect
INFO: Connected to mysql.default.svc:3306 at mysql-bin.000003/154 (sid:184054, cid:5)
2020-11-19 22:44:19,817 INFO Connected to MySQL binlog at mysql.default.svc:3306, starting at binlog file 'mysql-bin.000003', pos=154, skipping 0 events plus 0 rows (io.debezium.connector.mysql.BinlogReader) [blc-mysql.default.svc:3306]
2020-11-19 22:44:19,818 INFO Waiting for keepalive thread to start (io.debezium.connector.mysql.BinlogReader) [task-thread-debezium-connector-0]
2020-11-19 22:44:19,819 INFO Creating thread debezium-mysqlconnector-dbserver-mysql-binlog-client (io.debezium.util.Threads) [blc-mysql.default.svc:3306]
2020-11-19 22:44:19,823 INFO Keepalive thread is running (io.debezium.connector.mysql.BinlogReader) [task-thread-debezium-connector-0]
```

> You should be able to notice the line that says that you are not connected to `mysql.default.svc:3306`. Output formatted for the sake of readability

Hit <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the process.

`^C`{{execute ctrl-seq}}

### Inspect KafkaTopics

Now Kafka topics are created when the connector starts to capture database changes.

Those topics could be listed using command:

``oc get kafkatopics``{{execute interrupt}}

This should show you the topics corresponding to the database tables:

```bash
NAME                                                                                   PARTITIONS   REPLICATION FACTOR
consumer-offsets---84e7a678d08f4bd226872e5cdd4eb527fadc1c6a                            50           1
dbserver-mysql                                                                         1            1
dbserver-mysql.inventory.addresses                                                     1            1
dbserver-mysql.inventory.customers                                                     1            1
dbserver-mysql.inventory.geom                                                          1            1
dbserver-mysql.inventory.orders                                                        1            1
dbserver-mysql.inventory.products                                                      1            1
dbserver-mysql.inventory.products-on-hand---326f249c4c062fa00e3ec95752c453df16be9264   1            1
debezium-cluster-configs                                                               1            1
debezium-cluster-offsets                                                               25           1
debezium-cluster-status                                                                5            1
mysql.schema-changes.inventory                                                         1            1
test                                                                                   1            1
```

> Remember that AMQ streams operators also manages the topics of the Apache Kafka ecosystem.

### Verify data is sourced from the MySQL server to Kafka

Let's check the contents of `customers` table in MySQL. The command

``oc -n default exec -i deploy/mysql -- bash -c 'mysql -t -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT * from customers" inventory'``{{execute}}

You should get an outcome similar to the following:

```bash
mysql: [Warning] Using a password on the command line interface can be insecure.
+------+------------+-----------+-----------------------+
| id   | first_name | last_name | email                 |
+------+------------+-----------+-----------------------+
| 1001 | Sally      | Thomas    | sally.thomas@acme.com |
| 1002 | George     | Bailey    | gbailey@foobar.com    |
| 1003 | Edward     | Walker    | ed@walker.com         |
| 1004 | Anne       | Kretchmar | annek@noanswer.org    |
+------+------------+-----------+-----------------------+
```

The Kafka broker should contain an equivalent list of massages in topic `dbserver-mysql.inventory.customers` in the Debezium change event [format](http://debezium.io/docs/configuration/event-flattening/)

``oc exec -c kafka my-cluster-kafka-0 -- /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic dbserver-mysql.inventory.customers --from-beginning --max-messages 4 | jq``{{execute}}

>*Note:* Output formatted for the sake of readability

```json
...
{
  "schema": {
    "type": "struct",
    "fields": [
      {
        "type": "struct",
        "fields": [
          {
            "type": "int32",
            "optional": false,
            "field": "id"
          },
          {
            "type": "string",
            "optional": false,
            "field": "first_name"
          },
          {
            "type": "string",
            "optional": false,
            "field": "last_name"
          },
          {
            "type": "string",
            "optional": false,
            "field": "email"
          }
        ],
        "optional": true,
        "name": "dbserver_mysql.inventory.customers.Value",
        "field": "before"
      },
      {
        "type": "struct",
        "fields": [
          {
            "type": "int32",
            "optional": false,
            "field": "id"
          },
          {
            "type": "string",
            "optional": false,
            "field": "first_name"
          },
          {
            "type": "string",
            "optional": false,
            "field": "last_name"
          },
          {
            "type": "string",
            "optional": false,
            "field": "email"
          }
        ],
        "optional": true,
        "name": "dbserver_mysql.inventory.customers.Value",
        "field": "after"
      },
      {
        "type": "struct",
        "fields": [
          {
            "type": "string",
            "optional": false,
            "field": "version"
          },
          {
            "type": "string",
            "optional": false,
            "field": "connector"
          },
          {
            "type": "string",
            "optional": false,
            "field": "name"
          },
          {
            "type": "int64",
            "optional": false,
            "field": "ts_ms"
          },
          {
            "type": "string",
            "optional": true,
            "name": "io.debezium.data.Enum",
            "version": 1,
            "parameters": {
              "allowed": "true,last,false"
            },
            "default": "false",
            "field": "snapshot"
          },
          {
            "type": "string",
            "optional": false,
            "field": "db"
          },
          {
            "type": "string",
            "optional": true,
            "field": "table"
          },
          {
            "type": "int64",
            "optional": false,
            "field": "server_id"
          },
          {
            "type": "string",
            "optional": true,
            "field": "gtid"
          },
          {
            "type": "string",
            "optional": false,
            "field": "file"
          },
          {
            "type": "int64",
            "optional": false,
            "field": "pos"
          },
          {
            "type": "int32",
            "optional": false,
            "field": "row"
          },
          {
            "type": "int64",
            "optional": true,
            "field": "thread"
          },
          {
            "type": "string",
            "optional": true,
            "field": "query"
          }
        ],
        "optional": false,
        "name": "io.debezium.connector.mysql.Source",
        "field": "source"
      },
      {
        "type": "string",
        "optional": false,
        "field": "op"
      },
      {
        "type": "int64",
        "optional": true,
        "field": "ts_ms"
      },
      {
        "type": "struct",
        "fields": [
          {
            "type": "string",
            "optional": false,
            "field": "id"
          },
          {
            "type": "int64",
            "optional": false,
            "field": "total_order"
          },
          {
            "type": "int64",
            "optional": false,
            "field": "data_collection_order"
          }
        ],
        "optional": true,
        "field": "transaction"
      }
    ],
    "optional": false,
    "name": "dbserver_mysql.inventory.customers.Envelope"
  },
  "payload": {
    "before": null,
    "after": {
      "id": 1004,
      "first_name": "Anne",
      "last_name": "Kretchmar",
      "email": "annek@noanswer.org"
    },
    "source": {
      "version": "1.2.4.Final-redhat-00001",
      "connector": "mysql",
      "name": "dbserver-mysql",
      "ts_ms": 0,
      "snapshot": "true",
      "db": "inventory",
      "table": "customers",
      "server_id": 0,
      "gtid": null,
      "file": "mysql-bin.000003",
      "pos": 154,
      "row": 0,
      "thread": null,
      "query": null
    },
    "op": "c",
    "ts_ms": 1605824079863,
    "transaction": null
  }
}
Processed a total of 4 messages
```

If we add a new record to the table with this command:

``oc -n default exec -i deploy/mysql -- bash -c 'mysql -t -u $MYSQL_USER -p$MYSQL_PASSWORD -e "INSERT INTO customers VALUES(default,\"John\",\"Doe\",\"john.doe@example.org\")" inventory'``{{execute}}

A new message will be sent to the associated topic. Check the messages with this command:

``oc exec -c kafka my-cluster-kafka-0 -- /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic dbserver-mysql.inventory.customers --from-beginning --max-messages 5 | jq``{{execute}}

You should get a similar output:

```json
...
{
  "schema": {
    "type": "struct",
    "fields": [
      {
        "type": "struct",
        "fields": [
          {
            "type": "int32",
            "optional": false,
            "field": "id"
          },
          {
            "type": "string",
            "optional": false,
            "field": "first_name"
          },
          {
            "type": "string",
            "optional": false,
            "field": "last_name"
          },
          {
            "type": "string",
            "optional": false,
            "field": "email"
          }
        ],
        "optional": true,
        "name": "dbserver_mysql.inventory.customers.Value",
        "field": "before"
      },
      {
        "type": "struct",
        "fields": [
          {
            "type": "int32",
            "optional": false,
            "field": "id"
          },
          {
            "type": "string",
            "optional": false,
            "field": "first_name"
          },
          {
            "type": "string",
            "optional": false,
            "field": "last_name"
          },
          {
            "type": "string",
            "optional": false,
            "field": "email"
          }
        ],
        "optional": true,
        "name": "dbserver_mysql.inventory.customers.Value",
        "field": "after"
      },
      {
        "type": "struct",
        "fields": [
          {
            "type": "string",
            "optional": false,
            "field": "version"
          },
          {
            "type": "string",
            "optional": false,
            "field": "connector"
          },
          {
            "type": "string",
            "optional": false,
            "field": "name"
          },
          {
            "type": "int64",
            "optional": false,
            "field": "ts_ms"
          },
          {
            "type": "string",
            "optional": true,
            "name": "io.debezium.data.Enum",
            "version": 1,
            "parameters": {
              "allowed": "true,last,false"
            },
            "default": "false",
            "field": "snapshot"
          },
          {
            "type": "string",
            "optional": false,
            "field": "db"
          },
          {
            "type": "string",
            "optional": true,
            "field": "table"
          },
          {
            "type": "int64",
            "optional": false,
            "field": "server_id"
          },
          {
            "type": "string",
            "optional": true,
            "field": "gtid"
          },
          {
            "type": "string",
            "optional": false,
            "field": "file"
          },
          {
            "type": "int64",
            "optional": false,
            "field": "pos"
          },
          {
            "type": "int32",
            "optional": false,
            "field": "row"
          },
          {
            "type": "int64",
            "optional": true,
            "field": "thread"
          },
          {
            "type": "string",
            "optional": true,
            "field": "query"
          }
        ],
        "optional": false,
        "name": "io.debezium.connector.mysql.Source",
        "field": "source"
      },
      {
        "type": "string",
        "optional": false,
        "field": "op"
      },
      {
        "type": "int64",
        "optional": true,
        "field": "ts_ms"
      },
      {
        "type": "struct",
        "fields": [
          {
            "type": "string",
            "optional": false,
            "field": "id"
          },
          {
            "type": "int64",
            "optional": false,
            "field": "total_order"
          },
          {
            "type": "int64",
            "optional": false,
            "field": "data_collection_order"
          }
        ],
        "optional": true,
        "field": "transaction"
      }
    ],
    "optional": false,
    "name": "dbserver_mysql.inventory.customers.Envelope"
  },
  "payload": {
    "before": null,
    "after": {
      "id": 1005,
      "first_name": "John",
      "last_name": "Doe",
      "email": "john.doe@example.org"
    },
    "source": {
      "version": "1.2.4.Final-redhat-00001",
      "connector": "mysql",
      "name": "dbserver-mysql",
      "ts_ms": 1605824880000,
      "snapshot": "false",
      "db": "inventory",
      "table": "customers",
      "server_id": 223344,
      "gtid": null,
      "file": "mysql-bin.000003",
      "pos": 364,
      "row": 0,
      "thread": 7,
      "query": null
    },
    "op": "c",
    "ts_ms": 1605824880548,
    "transaction": null
  }
}
Processed a total of 5 messages
```

## Congratulations

You have completed the basic deployment scenario.
Now you can add or remove data from MySQL and see the results in Kafka Broker.

See Red Hat Integraton [documentation of Debezium](https://access.redhat.com/documentation/en-us/red_hat_integration/2020-q3/html/debezium_user_guide/index) for more tips and details.
