``oc port-forward $POD 5432:5432 &``{{execute}}

``jobs``{{execute}}

``psql sampledb username --host=127.0.0.1 --port=5432``{{execute}}

``\q``{{execute}}

``kill %1``{{execute}}
