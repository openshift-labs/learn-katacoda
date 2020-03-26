Let's talk to the CockroachDB cluster by connecting to the service from within the cluster. CockroachDB is PostgreSQL wire protocol compatible so there's a wide variety of supported clients. For the sake of example, we'll open up a SQL shell using CockroachDB's built-in shell and play around with it a bit.

```
oc run -it --rm cockroach-client --image=cockroachdb/cockroach --restart=Never --command -- ./cockroach sql --insecure --host $COCKROACHDB_PUBLIC_SERVICE
```{{execute}}
<br>
Once you see the SQL prompt, run the following to show the default databases:

```
SHOW DATABASES;
```{{execute}}
<br>
Create a new database called `bank` and populate a table with arbitrary values:

```
CREATE DATABASE bank;
CREATE TABLE bank.accounts (id INT PRIMARY KEY, balance DECIMAL);
INSERT INTO bank.accounts VALUES (1234, 10000.50);
```{{execute}}
<br>
Verify the table and values were successfully created:

```
SELECT * FROM bank.accounts;
```{{execute}}
<br>
Exit the SQL prompt:
```
\q
```{{execute}}