In the previous step you built a slightly more complex query including filtering, searching and paging capabilities.  In this step we'll add a Quarkus Lifecycle Hook to pre-populate the database with 10k records.

# Adding Lifecycle hook

You often need to execute custom actions when the application starts and clean up everything when the application stops. In this case we'll add an action that will pre-generate a lot of fake data.

Managed beans (like our `PersonResource`) can listen for lifecycle events by using the `@Observes` annotation on method signatures, which will be called when the associated event occurs.

Open the `src/main/java/org/acme/person/PersonResource.java`{{open}} resource class and then click **Copy To Editor** once again to inject the lifecycle listener:

<pre class="file" data-filename="./src/main/java/org/acme/person/PersonResource.java" data-target="insert" data-marker="// TODO: Add lifecycle hook">
@Transactional
    void onStart(@Observes StartupEvent ev) {
        for (int i = 0; i < 10000; i++) {
            String name = CuteNameGenerator.generate();
            LocalDate birth = LocalDate.now().plusWeeks(Math.round(Math.floor(Math.random() * 20 * 52 * -1)));
            EyeColor color = EyeColor.values()[(int)(Math.floor(Math.random() * EyeColor.values().length))];
            Person p = new Person();
            p.birth = birth;
            p.eyes = color;
            p.name = name;
            Person.persist(p);
        }
    }
</pre>

This code will insert 10,000 fake people with random birthdates, eye colors, and names at startup.

Although this is listening for `StartupEvent`, and our application has already started, in `quarkus:dev` mode Quarkus will still fire this event once. So let's test it out and see if it picks up our new data. We'll search for a single letter `F` and limit the results to `2`:

> Note that adding 10k entries will make startup time artificially high, around 5-10 seconds.

`curl -s "$PEOPLE_URL/person/datatable?draw=1&start=0&length=2&search\[value\]=F" | jq`{{execute T2}}

You should get up to 2 records returned, but the total number available should show many more indicating our search found many more, and the total number of records should now be `10003` (the 10k we added plus the 3 original values):

```json
{
  "data": [
    {
      "id": 1,
      "birth": "1974-08-15",
      "eyes": "BLUE",
      "name": "Farid Ulyanov"
    },
    {
      "id": 10,
      "birth": "2001-11-26",
      "eyes": "GREEN",
      "name": "Phantom Finger"
    }
  ],
  "draw": 1,
  "recordsFiltered": 1316,
  "recordsTotal": 10003
}
```

Note the values for `recordsFiltered` (the number of records with the letter `F` in the name), and `recordsTotal`. The value you see for `recordsFiltered` may be different than the above value, since the number of records with an `F` in the name may vary since the data is random.

# Congratulations

You have successfully written a lifecycle hook to listen for `StartupEvent`. Anytime the application is started it will fire this method. You can also use `@Observes ShutdownEvent` to do cleanup when the application is gracefully stopped.

In the next step we'll exercise the DataTables GUI, backed by our remotely developed, high performance Quarkus app!
