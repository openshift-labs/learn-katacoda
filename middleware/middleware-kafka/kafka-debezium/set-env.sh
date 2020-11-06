while [ ! -f debezium/setup-openshift.sh ]
do
  sleep 1
done
cd ~/debezium
. setup-openshift.sh
