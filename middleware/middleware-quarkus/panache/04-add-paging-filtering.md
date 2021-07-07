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
    public DataTable datatable(
        @QueryParam(value = "draw") int draw,
        @QueryParam(value = "start") int start,
        @QueryParam(value = "length") int length,
        @QueryParam(value = "search[value]") String searchVal

        ) {
            // TODO: Begin result

            // TODO: Filter based on search

            // TODO: Page and return

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

So, in our `PersonResource` endpoint, we'll start with an empty `result` object using the pre-created `DataTable` model. Click **Copy To Editor** to add this code:

<pre class="file" data-filename="./src/main/java/org/acme/person/PersonResource.java" data-target="insert" data-marker="// TODO: Begin result">
DataTable result = new DataTable();
            result.setDraw(draw);
</pre>

Next, if the request includes a search parameter, let's take care of that by including a search query, otherwise just collect all records:

<pre class="file" data-filename="./src/main/java/org/acme/person/PersonResource.java" data-target="insert" data-marker="// TODO: Filter based on search">
PanacheQuery&lt;Person&gt; filteredPeople;

            if (searchVal != null && !searchVal.isEmpty()) {
                filteredPeople = Person.&lt;Person&gt;find("name like :search",
                  Parameters.with("search", "%" + searchVal + "%"));
            } else {
                filteredPeople = Person.findAll();
            }
</pre>

And finally, we use the built-in Panache `page` operator to seek to the correct page of records and stream the number of entries desired, set the values into the `result` and return it:

<pre class="file" data-filename="./src/main/java/org/acme/person/PersonResource.java" data-target="insert" data-marker="// TODO: Page and return">
int page_number = start / length;
            filteredPeople.page(page_number, length);

            result.setRecordsFiltered(filteredPeople.count());
            result.setData(filteredPeople.list());
            result.setRecordsTotal(Person.count());

            return result;
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

