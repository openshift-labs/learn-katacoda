In this scenario the application being deployed consists of two components

## Backend

JavaEE based application that keeps a counter. Each request increments the counter by one.

The state is being stored on the file system.

As containers are ephemeral, the state would be lost on each restart, that's why we add 
storage to the compnent in the step 3.

## Frontend

Is a PHP based application that shows on each requests calls the backend to increment the
state and shows the number.

ToDo: Explain what is an application and what are components.
