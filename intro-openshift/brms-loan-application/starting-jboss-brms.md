To run the JBoss BRMS Business Central workbench, you will need a Docker environment on your local machine. We've prepared a JBoss BRMS Docker image for you and have made it available on Docker Hub.

To download and run JBoss BRMS, execute the following commands:

`docker pull duncandoyle/jboss-brms:6.4`{{copy}}

`docker run -p 8001:8001 -p 8080:8080 -p 9418:9418 -t -i --name=jboss-brms duncandoyle/jboss-brms:6.4`{{copy}}

After the platform has started, you can access the Business Central workbench at (http://{docker-host}:8080/business-central)

- username: brmsAdmin
- password: jbossbrms1!

If all is well, you will be presented with the following screen:

![Business Central](../assets/brms-index.png)
