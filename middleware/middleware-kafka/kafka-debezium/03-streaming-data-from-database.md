The last step to do is to create a link between Debezium and a source MySQL database.
This is achieved via Kafka Connect [REST API](https://docs.confluent.io/current/connect/restapi.html) configuration.

![Complete deployment](../../assets/middleware/debezium-getting-started/minimal-deployment.png)

**1. Register database source**

To register the source we need to send a `POST` request to the `/connectors` endpoint of Kafka Connect API.
An example registration request is part of the evironment - `register.json`{{open}}.

To register the database source execute

``cat register.json | oc exec -i -c kafka my-cluster-kafka-0 -- curl -s -X POST -H "Accept:application/json" -H "Content-Type:application/json" http://my-connect-cluster-connect-api:8083/connectors -d @-``{{execute}}

Check the Connect's log file to see that the registration has succeeded and change data capture has started

``oc logs $(oc get pods -o name -l app=strimzi-connect-s2i)``{{execute}}

Now Kafka topics are created when the connector starts to capture database changes.
Those topics could be listed using command

``oc exec -c kafka my-cluster-kafka-0 -- /opt/kafka/bin/kafka-topics.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --list``{{execute}}

And the topics corresponding to the database tables are

    dbserver1.inventory.addresses
    dbserver1.inventory.customers
    dbserver1.inventory.geom
    dbserver1.inventory.orders
    dbserver1.inventory.products
    dbserver1.inventory.products_on_hand

**2. Verify that data are sourced from the MySQL server to the Kafka broker**

Let's check the contents of `customers` table in MySQL. The command

``oc exec -i $(oc get pods -o custom-columns=NAME:.metadata.name --no-headers -l app=mysql) -- bash -c 'mysql -t -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT * from customers" inventory'``{{execute}}

should yield a result

    +------+------------+-----------+-----------------------+
    | id   | first_name | last_name | email                 |
    +------+------------+-----------+-----------------------+
    | 1001 | Sally      | Thomas    | sally.thomas@acme.com |
    | 1002 | George     | Bailey    | gbailey@foobar.com    |
    | 1003 | Edward     | Walker    | ed@walker.com         |
    | 1004 | Anne       | Kretchmar | annek@noanswer.org    |
    +------+------------+-----------+-----------------------+

The Kafka broker should contain an equivalent list of massages in topic `dbserver1.inventory.customers` in the Debezium change event [format](http://debezium.io/docs/configuration/event-flattening/)

``oc exec -c kafka my-cluster-kafka-0 -- /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic dbserver1.inventory.customers --from-beginning --max-messages 4``{{execute}}

>*Note:* Output formatted for the sake of readability

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
            "name": "dbserver1.inventory.customers.Value",
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
            "name": "dbserver1.inventory.customers.Value",
            "field": "after"
          },
          {
            "type": "struct",
            "fields": [
              {
                "type": "string",
                "optional": false,
                "field": "name"
              },
              {
                "type": "int64",
                "optional": false,
                "field": "server_id"
              },
              {
                "type": "int64",
                "optional": false,
                "field": "ts_sec"
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
                "type": "boolean",
                "optional": true,
                "field": "snapshot"
              },
              {
                "type": "int64",
                "optional": true,
                "field": "thread"
              },
              {
                "type": "string",
                "optional": true,
                "field": "db"
              },
              {
                "type": "string",
                "optional": true,
                "field": "table"
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
          }
        ],
        "optional": false,
        "name": "dbserver1.inventory.customers.Envelope",
        "version": 1
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
          "name": "dbserver1",
          "server_id": 0,
          "ts_sec": 0,
          "gtid": null,
          "file": "mysql-bin.000003",
          "pos": 154,
          "row": 0,
          "snapshot": true,
          "thread": null,
          "db": "inventory",
          "table": "customers"
        },
        "op": "c",
        "ts_ms": 1513066125526
      }
    }
    Processed a total of 4 messages
    
If we add a new record to the table

``oc exec -i $(oc get pods -o custom-columns=NAME:.metadata.name --no-headers -l app=mysql) -- bash -c 'mysql -t -u $MYSQL_USER -p$MYSQL_PASSWORD -e "INSERT INTO customers VALUES(default,\"John\",\"Doe\",\"john.doe@example.org\")" inventory'``{{execute}}

a new message will be sent to the associated topic

``oc exec -c kafka my-cluster-kafka-0 -- /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic dbserver1.inventory.customers --from-beginning --max-messages 5``{{execute}}

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
            "name": "dbserver1.inventory.customers.Value",
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
            "name": "dbserver1.inventory.customers.Value",
            "field": "after"
          },
          {
            "type": "struct",
            "fields": [
              {
                "type": "string",
                "optional": false,
                "field": "name"
              },
              {
                "type": "int64",
                "optional": false,
                "field": "server_id"
              },
              {
                "type": "int64",
                "optional": false,
                "field": "ts_sec"
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
                "type": "boolean",
                "optional": true,
                "field": "snapshot"
              },
              {
                "type": "int64",
                "optional": true,
                "field": "thread"
              },
              {
                "type": "string",
                "optional": true,
                "field": "db"
              },
              {
                "type": "string",
                "optional": true,
                "field": "table"
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
          }
        ],
        "optional": false,
        "name": "dbserver1.inventory.customers.Envelope",
        "version": 1
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
          "name": "dbserver1",
          "server_id": 0,
          "ts_sec": 0,
          "gtid": null,
          "file": "mysql-bin.000003",
          "pos": 465,
          "row": 0,
          "snapshot": true,
          "thread": null,
          "db": "inventory",
          "table": "customers"
        },
        "op": "c",
        "ts_ms": 1513068550815
      }
    }
    Processed a total of 5 messages

## Congratulations

You have completed the basic deployment scenario.
Now you can add or remove data from MySQL and see the results in Kafka Broker.

See Debezium's extensive [tutorial](http://debezium.io/docs/tutorial/) for more tips and details.
