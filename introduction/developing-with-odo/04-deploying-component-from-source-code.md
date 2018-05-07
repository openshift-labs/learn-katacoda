With the `backend` component running and connected to persistent storage, we are ready to bring up the frontend component and connect it to the backend. Once again, source code for the component is already available in the command line environment. Change directories to the `frontend` directory.

`cd ~/frontend`{{execute}}

Listing the contents of this directory shows that `frontend` is a simple PHP application.

`ls`{{execute}}

Since `frontend` is written in an interpreted language, there is no build step analogous to the maven build we performed for the `backend` component. We can proceed directly to specifying the `php` environment from the cluster's Software Catalog, shown earlier when we ran `odo catalog list`.

We give this php-based component the name `frontend`.

`odo create php frontend`{{execute}}

With the component named and created, we can `push` our PHP source code from the current directory, `frontend`.

`odo push`{{execute}}

`Odo` will announce the operation with output like:

```
Pushing changes to component: frontend
```

until the push completes, when `odo` will print:

```
changes successfully pushed to component: frontend
```
