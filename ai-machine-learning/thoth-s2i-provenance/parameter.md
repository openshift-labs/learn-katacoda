Now finally let's explore the options Thoth s2i build image offers - 

Thoth’s s2i container images can be configured using environment variables supplied to the build config:

`THOTH_PROVENANCE_CHECK` - verify stack provenance - the provenance check is triggered only if the lock file is not comming from Thoth’s recommendation engine (otherwise the stack has already verified provenance)

`THOTH_ADVISE` - always use the recommended stack by Thoth (even if Pipfile.lock is present in the repo)

`THOTH_ASSEMBLE_DEBUG` - run s2i’s assemble script in verbose mode

`THOTH_DRY_RUN` - submit stack to Thoth’s recommendation engine but do not use the recommended Pipfile.lock file, use the Pipfile.lock file present in the repo instead

`THOTH_FROM_MASTER` - Use Thamos from git instead of a PyPI release - handy if the released Thamos has a bug which was fixed in the master branch

`THOTH_HOST` - Thoth’s host to reach out to for recommendations (defaults to prod deployment at khemenu.thoth-station.ninja)

`THOTH_ERROR_FALLBACK` - fallback to the Pipfile.lock present in the repository if the submitted Thoth analysis fails

If you go checkout the `openshift.yaml` in [s2i-example/log-thoth-broken](https://github.com/thoth-station/s2i-example/blob/log-thoth-broken/openshift.yaml) and checkout the env block under BuildConfig (ln 57), you will see some of these being used like `THOTH_PROVENANCE_CHECK`, `THAMOS_ADVISE`, `THOTH_DRY_RUN`, `THOTH_HOST`.
Thamos Host is currently set to `api.moc.thoth-station.ninja`, which is our public facing api. 
And `THOTH_PROVENANCE_CHECK` set to 1, that triggers the provenance check. For this tutorial we have turned of `THOTH_ADVISE=0` to focus on provenance checks only.


Here are some config option's that you could configure, which 
changes the behaviour of `Thamos` (the cli tool used to interact with Thoth internally.) 
 - https://thoth-station.ninja/docs/developers/thamos/

These env variables can be toggles according to your needs in the `openshift.yaml`.