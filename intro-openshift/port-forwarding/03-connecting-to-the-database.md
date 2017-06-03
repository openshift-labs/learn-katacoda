Option 1.

``POD=`oc get pods --selector app=dbname -o name | sed -e 's%pod/%%'```{{execute HOST1}}

``oc port-forward $POD 5432:5432``{{execute HOST1}}

``psql dbname dbuser --host=127.0.0.1 --port=5432``{{execute HOST2}}

Option 2.

``oc port-forward `oc get pods --selector app=dbname -o name | sed -e 's%pod/%%'` 5432:5432 &``{{execute HOST1}}

``psql dbname dbuser --host=127.0.0.1 --port=5432``{{execute HOST1}}

Option 3.

``oc port-forward `oc get pods --selector app=dbname -o custom-columns=name:.metadata.name --no-headers` 5432:5432 &``{{execute HOST1}}

``psql dbname dbuser --host=127.0.0.1 --port=5432``{{execute HOST1}}

``\q``{{execute}}

``kill %1``{{execute}}
