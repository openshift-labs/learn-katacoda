Now we are ready to run the batch application. 
We will use ``curl`` command line tool to invoke REST API to perform various batch processing operations.
The JSON output is formatted with ``python -m json.tool``

To start the job named ``csv2db``:

``curl -s -X POST -H 'Content-Type:application/json' "http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobs/csv2db/start" | python -m json.tool``{{execute}}

```json
{
   "startTime":null,
   "endTime":null,
   "batchStatus":"STARTING",
   "exitStatus":null,
   "executionId":1,
   "href":"http://intro-jberet-jberet-lab.2886795305-80-ollie02.environments.katacoda.com/intro-jberet/api/jobexecutions/1",
   "createTime":1506284588752,
   "lastUpdatedTime":1506284588752,
   "jobParameters":null,
   "jobName":"csv2db",
   "jobInstanceId":1
}
```

Our application uses the following database parameters, as specified when we deployed PostgreSQL database:

* ``db.host: postgresql``
* ``db.name: sampledb``
* ``db.user: jberet``
* ``db.password: jberet``

If you've configured different values when creating PostgreSQL, you will need to include them as
query parameters in test URL.

The ``href`` value in the ``curl`` command output indicates the address for the newly-created
job execution resource. To get its details and status, run the following command: 

``curl -s http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobexecutions/1 | python -m json.tool``{{execute}}

The output is the same as above, except that the job has completed and its batch status 
is updated to ``COMPLETED``

To get all step executions belonging to this job execution:

``curl -s http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobexecutions/1/stepexecutions/ | python -m json.tool``{{execute}}

The output should include 2 step executions (details omitted here).

To get details for the 2nd step execution, which performs the reading and writing of batch data:

``curl -s http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobexecutions/1/stepexecutions/2 | python -m json.tool``{{execute}}

```json
{
   "startTime":1506284589019,
   "endTime":1506284591953,
   "batchStatus":"COMPLETED",
   "exitStatus":"COMPLETED",
   "stepExecutionId":2,
   "stepName":"csv2db.step2",
   "metrics":[
      {
         "type":"WRITE_COUNT",
         "value":100
      },
      {
         "type":"ROLLBACK_COUNT",
         "value":0
      },
      {
         "type":"FILTER_COUNT",
         "value":0
      },
      {
         "type":"WRITE_SKIP_COUNT",
         "value":0
      },
      {
         "type":"PROCESS_SKIP_COUNT",
         "value":0
      },
      {
         "type":"COMMIT_COUNT",
         "value":11
      },
      {
         "type":"READ_SKIP_COUNT",
         "value":0
      },
      {
         "type":"READ_COUNT",
         "value":100
      }
   ]
}
```
Just some notes about the step metrics:

* ``READ_COUNT: 100`` indicates 100 items were read from CSV; 
* ``WRITE_COUNT: 100`` indicates 100 items were written to database
* ``COMMIT_COUNT: 11`` indicates all these items were split into chunks with 11 transactions

You may want to check the output table ```MOVIES```, just to verify that the correct data have
been saved. We can do that by remotely accessing PostgreSQL POD and running ``psql`` tool.

In order to know where the database is running, run the command:

``oc get pods --selector app=postgresql``{{execute}}

This will output the details of the pod which is running the database.

```
NAME               READY     STATUS    RESTARTS   AGE
postgresql-1-sqf9v   1/1       Running   0          1m
```

To make it easier to reference the name of the pod, capture the name of the pod in an environment variable by running:

``POD=`oc get pods --selector app=postgresql -o custom-columns=name:.metadata.name --no-headers`; echo $POD``{{execute}}

To create an interactive shell within the same container running the database, you can use the ``oc rsh`` command, supplying it the name of the pod.

``oc rsh $POD``{{execute}}

To start ``psql`` tool:

``psql sampledb jberet``{{execute}}

This will present you with the prompt for running database operations via ``psql``.

```
psql (9.5.7)
Type "help" for help.

sampledb=>
```

To check the content of ``MOVIES`` table:

``SELECT * FROM MOVIES;``{{execute}}

There should be 100 rows in ``MOVIES`` table in paginated view. Press ``space`` for next page, or ``q`` to stop.

```
 rank |                        tit                        |      grs      |    opn
------+---------------------------------------------------+---------------+------------
    1 | Marvel's The Avengers                             | 623357910.000 | 2012-05-04
    2 | The Dark Knight Rises                             | 448139099.000 | 2012-07-20
    3 | The Hunger Games                                  | 408010692.000 | 2012-03-23
    4 | Skyfall                                           | 304360277.000 | 2012-11-09
    5 | The Hobbit: An Unexpected Journey                 | 303003568.000 | 2012-12-14
``` 

To exit ``psql``:

``\q``{{execute}}

To exit the PostgreSQL POD interactive shell:

``exit``{{execute}}


