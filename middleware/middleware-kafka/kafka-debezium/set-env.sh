echo "Waiting for project..."
while [ ! -f /root/projects/debezium/kafka-cluster.yaml ]; do sleep 1; done # wait for the setup.sh file to exist
sleep 10
echo "Ready"