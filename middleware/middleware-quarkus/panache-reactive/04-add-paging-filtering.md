In the previous step you added a few more custom queries to your entity and the associated RESTful endpoints. In this step we'll build a slightly more complex query including filtering, searching and paging capabilities.

# Showing data in tables

Earlier we used `curl` to access our data, which is very useful for testing, but for real applications you will usually surface the data in other ways, like on web pages using tables, with options for searching, sorting, filtering, paging, etc. Quarkus and Panache make this easy to adapt your application for any display library or framework.

Let's use a popular jQuery-based plugin called [DataTables](https://www.datatables.net/). It features a *server-side* processing mode where it depends on the server (in this case our Quarkus app) to do searching, filtering, sorting, and paging. This is useful for very large datasets, on the order of hundreds of thousands of records or more. Transmitting the entire data set to the client browser is ineffecient at best, and will crash browsers, increase networking usage, and frustrate users at worst. So let's just return the exact data needed to be shown.

# Add new endpoint

[DataTables documentation](https://www.datatables.net/manual/server-side) shows that its frontend will call an endpoint on the backend to retrieve some amount of data. It will pass several query parameters to tell the server what to sort, filter, search, and which data to return based on the page size and current page the user is viewing. For this example, we'll only support a subset:

* `start` - The index of the first element needed
* `length` - Total number records to return (or less, if there are less records that meet criteria)
* `search[value]` - The value of the search box
* `draw` - DataTables does asnychronous processing, so this value is sent with each request, expecting it to be returned as-is, so DataTables can piece things back together on the frontend if a user clicks things quickly.

Open the `src/main/java/org/acme/person/PersonResource.java`{{open}} resource class and then click **Copy To Editor** once again to inject the new endpoint:

<pre class="file" data-filename="./src/main/java/org/acme/person/PersonResource.java" data-target="insert" data-marker="// TODO: add datatable query">
@GET
    @Path("/datatable")
    @Produces(MediaType.APPLICATION_JSON)
    public Uni&lt;DataTable&gt; datatable(@QueryParam("draw") int draw, @QueryParam("start") int start, @QueryParam("length") int length, @QueryParam("search[value]") String searchVal) {
      // TODO: Construct query

      // TODO: Execute pipeline

    }
</pre>

Here we are using JAX-RS `@QueryParam` values to specify the incoming parameters and be able to use them when the frontend calls the `GET /person/datatable` endpoint.

We'll fill in the `TODO`s to build this method.

DataTables requires a specific JSON payload to be returned from this, and we've pre-created a POJO `DataTable` class representing this structure in `src/main/java/org/acme/person/model/DataTable.java`. This simple structure includes these fields:

* `draw` - The async processing record id
* `recordsTotal` - Total records in database
* `recordsFiltered` - Total records that match filtering criteria
* `data` - The actual array of records
* `error` - Error string, if any

We need to assemble a reactive pipeline that produces a `Uni<DataTable>`. The pipeline will consist of the following steps:

1. Construct the proper `PanacheQuery` pipeline based on the value of the `search[value]` parameter
2. Execute `PanacheQuery.list()` to capture the results
3. Convert the `List` of `Person`s into a `DataTable` instance
4. Fill in the `DataTable.recordsTotal` field from the `Person.count()` result

Click **Copy To Editor** to add this code, which performs step 1 in the above sequence:

<pre class="file" data-filename="./src/main/java/org/acme/person/PersonResource.java" data-target="insert" data-marker="// TODO: Construct query">
int pageNumber = start / length;

        PanacheQuery&lt;Person&gt; filteredPeople = Optional.ofNullable(searchVal)
            .filter(val -&gt; !val.isEmpty())
            .map(val -&gt; Person.&lt;Person&gt;find("name like :search", Parameters.with("search", "%" + val + "%")))
            .orElseGet(() -&gt; Person.findAll())
            .page(pageNumber, length);
</pre>

Next, execute the pipeline and convert the results into a `DataTable` instance.

<pre class="file" data-filename="./src/main/java/org/acme/person/PersonResource.java" data-target="insert" data-marker="// TODO: Execute pipeline">
return filteredPeople.list()
        .map(people -&gt; {   // Convert List&lt;Person&gt; to DataTable
            DataTable result = new DataTable();
            result.setDraw(draw);
            result.setData(people);

            return result;
        })
        .flatMap(datatable -&gt; Person.count().map(recordsTotal -&gt; {   // Get the total records count
            datatable.setRecordsTotal(recordsTotal);
            return datatable;
        }))
        .flatMap(datatable -&gt; filteredPeople.count().map(recordsFilteredCount -&gt; {   // Get the number of records filtered
            datatable.setRecordsFiltered(recordsFilteredCount);
            return datatable;
        }));
</pre>

Let's test out our new endpoint using `curl` to search for names with `yan` in their name:

`curl -s "$PEOPLE_URL/person/datatable?draw=1&start=0&length=10&search\[value\]=yan" | jq`{{execute T2}}

This should return a single entity (since in our 3-person sample data, only one has `yan` in their name), embedded in the return object that DataTable is expecting (with the `draw`, `recordsFiltered`, `recordsTotal` etc):

```json
{
  "data": [
    {
      "id": 1,
      "birth": "1974-08-15",
      "eyes": "BLUE",
      "name": "Farid Ulyanov"
    }
  ],
  "draw": 1,
  "recordsFiltered": 1,
  "recordsTotal": 3
}
```
# Congratulations

You have successfully written an endpoint that can be used with 3rd-party frontend plugins like DataTable. In the next step we'll create a lot more data and deploy to OpenShift.

