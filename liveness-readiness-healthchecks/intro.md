In this scenario, you'll learn how OpenShift checks containers health using Readiness and Liveness Probes.

Readiness Probes checks if an application is ready to start processing traffic. This probe solves the problem of the container having started, but the process still warming up and configuring itself meaning it's not ready to receive traffic.

Liveness Probes ensure that the application is healthy and capable of processing requests.
