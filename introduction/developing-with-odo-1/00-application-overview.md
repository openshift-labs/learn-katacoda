The application you will be deploying is a wild west shooter style game.

Applications are often divided into components based on a logical division of labor. For example, an application might consist of a data-storage, backend component that performs the application's primary work and stores the results. The backend component is paired with a user interface, frontend component that accesses the backend to retrieve data and displays it to a user.

The application deployed in this tutorial consists of two such components.

## Backend

The backend is a Java Spring Boot application. It performs queries against the Kubernetes and OpenShift REST APIs to retrieve a list of the resource objects that were created when you deployed the application. Then, it returns details about these resource objects to the frontend.

## Frontend

The frontend is the user interface for a wild west style game written in Node.js. It displays popup images which you can shoot, corresponding to the resource objects returned by the backend.
