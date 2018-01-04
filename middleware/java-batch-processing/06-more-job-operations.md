Restarting a job execution is a common batch job operation, when the previous job execution
failed or was stopped. Let's first start a job execution with wrong configuration, expecting
it to fail so we can restart it next.

To start ``csv2db`` job with wrong ``db.host`` value:

``curl -s -X POST -H 'Content-Type:application/json' "http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobs/csv2db/start?db.host=x" | python -m json.tool``{{execute}}

Check the status of the above job execution, which should be ``FAILED`` when it's finished running:

``curl -s http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobexecutions/2 | python -m json.tool``{{execute}}

To restart the above failed job execution, with correct configuration:

``curl -s -X POST -H 'Content-Type:application/json' "http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobexecutions/2/restart?db.host=postgresql" | python -m json.tool``{{execute}}

Restarting creates a new job execution. Check the status of the restart job execution, which should be ``COMPLETED`` when it's finished running:

``curl -s http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobexecutions/3 | python -m json.tool``{{execute}}

If a job execution is taking too long, you may want to stop it. Note that you can only
stop a running job execution, and apply ``stop`` operation on job execution in other state
will fail. Since the duration of our sample job execution is short, let's try stopping a
completed job execution, expecting the stop operation to fail:

``curl -s -X POST -H 'Content-Type:application/json' "http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobexecutions/2/stop" | python -m json.tool``{{execute}}

You should see output like this with long stacktrace:

```json
{
  "type":"javax.batch.operations.JobExecutionNotRunningException",
  "message":"JBERET000612: Job execution 2 has batch status FAILED, and is not running.",
  "stackTrace":"javax.batch.operations.JobExecutionNotRunningException: ..."
}
```

To abandon a finished job execution:

``curl -s -X POST -H 'Content-Type:application/json' "http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobexecutions/2/abandon"``{{execute}}

Note that you can only abandon a finished job execution, not running ones. Once a job execution is abandoned,
it cannot be restarted.

To schedule a job execution:

``curl -s -X POST -H 'Content-Type:application/json' -d '{"jobName":"csv2db", "initialDelay":1, "interval":60}' "http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobs/csv2db/schedule" | python -m json.tool``{{execute}}

And you will see the resultant job schedule information as output:

```text
{
  "id":"1",
  "jobScheduleConfig":{
    "jobName":"csv2db",
    "jobExecutionId":0,
    "jobParameters":null,
    "scheduleExpression":null,
    "initialDelay":1,
    "afterDelay":0,
    "interval":60,
    "persistent":false
  },
  "createTime":1508094664385,
  "status":"SCHEDULED",
  "jobExecutionIds":[]
}
```

The above command schedules to run job `csv2db` after 1 minute, and every 60 minutes.
Note that its status is ``SCHEDULED``, and its associated job executions are an empty array, since
no job execution has been started for this schedule.
More advanced scheduling are also supported by JBeret such as repeated execution, interval between executions, 
and calendar-based cron-like schedules.

To list all job schedules:

``curl -s "http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/schedules" | python -m json.tool``{{execute}}

Your output may be like this:

```text
[
  {
    "id":"1",
    "jobScheduleConfig":{
      "jobName":"csv2db",
      "jobExecutionId":0,
      "jobParameters":null,
      "scheduleExpression":null,
      "initialDelay":1,
      "afterDelay":0,
      "interval":60,
      "persistent":false
    },
    "createTime":1508094664385,
    "status":"SCHEDULED",
    "jobExecutionIds":[
      4
    ]
  }
]
```
From the above output, we can see there is 1 job schedule, which has been fulfilled once with job execution id ``4``.
Its status remains ``SCHEDULED``, since it's a recurring job schedule with more job executions to come.

To cancel the above recurring job schedule:

``curl -s -X POST -H 'Content-Type:application/json' "http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/schedules/1/cancel"``{{execute}}

Then re-run the previous command to list job schedules, to verify their status:

``curl -s "http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/schedules" | python -m json.tool``{{execute}}

The output should show that the job schedule ``1`` is in ``CANCELLED`` status:

```text
[
  {
    "id":"1",
    "jobScheduleConfig":{
      "jobName":"csv2db",
      "jobExecutionId":0,
      "jobParameters":null,
      "scheduleExpression":null,
      "initialDelay":1,
      "afterDelay":0,
      "interval":60,
      "persistent":false
    },
    "createTime":1508094664385,
    "status":"CANCELLED",
    "jobExecutionIds":[
      4
    ]
  }
]
```

