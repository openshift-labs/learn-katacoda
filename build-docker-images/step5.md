If a rebuild is required, for example, after a code change, then it is possible to force a manual build via the CLI.

## Task

The following starts a new build using `oc start-build frontend`{{execute}}

The build will take advantage of existing Git Repo and Docker Layer caches to reduce build time. The status can be viewed using `oc get builds`{{execute}}.

After it is complete, the new version will be deployed. It is possible to see the revision currently running via `oc get dc`{{execute}}

If a build hangs or was started by mistake, it can be cancelled using the ID, for example, `oc cancel-build frontend-2`{{execute}}

A rebuild can also be triggered via Webhooks. Each project is assigned a unique URL that automatically starts a build. This URL
