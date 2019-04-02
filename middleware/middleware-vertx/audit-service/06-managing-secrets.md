## Managing Secrets

But wait…​ we have hardcoded the database credentials in our code. This is not optimal. OpenShift provides a way to manage secrets.

Let’s first create a Secret entity using:

`oc create -f src/kubernetes/database-secret.yaml`{{execute}}

You can open the specified file and see how this object is structured. Basically it’s a set of key/value pairs.

There are several ways to access secrets from your application:

1, ENV variables
2. Mounted as a file
3. Using the Vert.x config

For sake of simplicity we are going to use the first approach.

So, we first need to bind the secret with our deployment. 

Open `audit-service/src/main/fabric8/deployment.yml`{{open}} and copy the following content (or uncomment the commented part):

```yaml
spec:
  template:
    spec:
      containers:
        - name: vertx
          env:
            - name: KUBERNETES_NAMESPACE
              valueFrom:
                fieldRef:
                  apiVersion: v1
                  fieldPath: metadata.namespace
            - name: JAVA_OPTIONS
              value: '-Dvertx.cacheDirBase=/tmp -Dvertx.jgroups.config=default-configs/default-jgroups-kubernetes.xml -Djava.net.preferIPv4Stack=true'
            - name: JAVA_ARGS
              value: '-cluster'
            - name: DB_USERNAME
              valueFrom:
                 secretKeyRef:
                   name: audit-database-config
                   key: user
            - name: DB_PASSWORD
              valueFrom:
                 secretKeyRef:
                   name: audit-database-config
                   key: password
            - name: DB_URL
              valueFrom:
                secretKeyRef:
                  name: audit-database-config
                  key: url
```

Notice the 3 last env variables retrieving values from the audit-database-config secret.

Now, we need to update our code. Open `io.vertx.workshop.audit.impl.AuditVerticle` and replace the content of the `getDatabaseConfiguration` method with:

```java
return new JsonObject()
    .put("user", System.getenv("DB_USERNAME"))
    .put("password", System.getenv("DB_PASSWORD"))
    .put("driver_class", "org.postgresql.Driver")
    .put("url", System.getenv("DB_URL"));
```

And redeploy your service using: 

`mvn fabric8:undeploy fabric8:deploy`{{execute}}

Voilà! we have externalized the credentials from the application.