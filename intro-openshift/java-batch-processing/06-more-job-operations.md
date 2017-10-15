Restarting a job execution is a common batch job operation, when the previous job execution
failed or was stopped. Let's first start a job execution with wrong configuration, expecting
it to fail so we can restart it next.

To start ``csv2db`` job with wrong ``db.host`` value:

``curl -X POST -H 'Content-Type:application/json' "http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobs/csv2db/start?db.host=x"``{{execute}}

Check the status of the above job execution, which should be ``FAILED`` when it's finished running:

``curl http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobexecutions/2``{{execute}}

To restart the above failed job execution, with correct configuration:

``curl -X POST -H 'Content-Type:application/json' "http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobexecutions/2/restart?db.host=postgresql"``{{execute}}

Restarting creates a new job execution. Check the status of the restart job execution, which should be ``COMPLETED`` when it's finished running:

``curl http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobexecutions/3``{{execute}}

If a job execution is taking too long, you may want to stop it. Note that you can only
stop a running job execution, and apply ``stop`` operation on job execution in other state
will fail. Since the duration of our sample job execution is short, let's try stopping a
completed job execution, expecting the stop operation to fail:

``curl -X POST -H 'Content-Type:application/json' "http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobexecutions/2/stop"``{{execute}}

You should see output like this:

```json
{
  "type":"javax.batch.operations.JobExecutionNotRunningException",
  "message":"JBERET000612: Job execution 2 has batch status FAILED, and is not running.",
  "stackTrace":"javax.batch.operations.JobExecutionNotRunningException: ..."
}
```

To abandon a finished job execution:

``curl -X POST -H 'Content-Type:application/json' "http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobexecutions/2/abandon"``{{execute}}

Note that you can only abandon a finished job execution, not running ones. Once a job execution is abandoned,
it cannot be restarted.

To schedule a job execution:

``curl -X POST -H 'Content-Type:application/json' -d '{"jobName":"csv2db", "initialDelay":1, "interval":60}' "http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/jobs/csv2db/schedule"``{{execute}}

The above command schedules to run job `csv2db` after 1 minute, and every 60 minutes.
More advanced scheduling are also supported by JBeret such as repeated execution, interval between executions, 
and calendar-based cron-like schedules.

To list all job schedules:

``curl "http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/schedules"``{{execute}}

To cancel the above recurring job schedule:

``curl -X POST -H 'Content-Type:application/json' "http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/intro-jberet/api/schedules/1/cancel"``{{execute}}


