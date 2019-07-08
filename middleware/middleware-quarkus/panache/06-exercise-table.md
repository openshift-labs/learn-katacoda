Now that we have our app running on OpenShift, let's see what we can do.

Click to [access the graphical frontend which includes our DataTable](http://quarkus-datatable-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com)

It should look like:

![Web Console Overview](/openshift/assets/middleware/quarkus/panache-datatable.png)

Notice the total number of records reported at the bottom. Type in a single letter, e.g. `F` in the search box and see how responsive the app is. Type additional letters to narrow the search. Rather than having all 10k records loaded in the browser, DataTable makes a call back to our `/person/datatable` REST endpoint to fetch only those records that should be shown, based on page size, current page you're looking at, and any search filters. With a page size of `10` each REST call will only return up to 10 records, no matter how many there are in the database.

Skip around a few pages, try some different searches, and notice that the data is only loaded when needed. The overall performance is very good even for low-bandwidth connections or huge data sets.

## Congratulations

In this scenario you got a glimpse of the power of Quarkus apps when dealing with large amounts of data. There is much more to Quarkus than fast startup times and low resource usage, so keep on exploring additional scenarios to learn more, and be sure to visit [quarkus.io](https://quarkus.io) to learn even more about the architecture and capabilities of this exciting new framework for Java developers. 

# Extra Credit

There are [many other features of DataTables](https://datatables.net/manual/server-side) that could be supported on the server side with Quarkus and Panache. For example, when our endpoint is accessed, the set of columns to order on is also passed using the `order` and `columns` arrays, which we do not cover in this scenario. If you have time, try to add additional code to support these incoming parameters and order the resulting records accordingly!
