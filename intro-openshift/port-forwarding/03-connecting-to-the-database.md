``POD=`oc get pods dbname -o name``{{execute HOST1}}

``oc port-forward $POD 5432:5432``{{execute HOST1}}

``psql dbname dbuser --port=5432``{{execute HOST2}}