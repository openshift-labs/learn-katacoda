Applications perform some useful function for a user. To organize design and development, applications are often divided into components based on a logical division of labor. For example, an application might consist of a data-storage "backend" component that performs the application's primary work and permanently stores the results, paired with a user interface "frontend" component that accesses the backend to retrieve data and display it to a user.

The application deployed in this lesson consists of two such components, a display-oriented frontend, and a backend that performs a simple calculation and storage for the calculation's results. This scenario uses these two components to illustrate the basics of working with the `odo` tool for managing applications on OpenShift.

## Backend

The application backend is a JavaEE application that maintains a request count. Each request increments the count by one. The counter state is stored in a file. We attach persistent storage to the backend component so that the counter state is maintained when containers are scaled or restarted.

## Frontend

Our application's frontend, written in PHP, accepts client requests, calls the backend to update the request counter, and displays to the client web browser the resulting running count of requests.
