
``oc new-app postgresql-ephemeral --param DATABASE_SERVICE_NAME=dbname --param POSTGRESQL_DATABASE=dbname --param POSTGRESQL_USER=dbuser --param POSTGRESQL_PASSWORD=dbpassword``{{execute HOST1}}

``oc rollout status dc/dbname``{{execute HOST1}}
