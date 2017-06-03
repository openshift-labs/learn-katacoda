``POD=`oc get pods --selector app=dbname -o name | sed -e 's%pod/%%'```{{execute HOST1}}

``oc port-forward $POD 5432:5432``{{execute HOST1}}

``psql dbname dbuser --host=127.0.0.1 --port=5432``{{execute HOST2}}