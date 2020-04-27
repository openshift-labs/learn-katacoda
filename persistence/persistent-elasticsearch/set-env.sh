launch.sh
until [ -f /root/install_ocs.sh ]; do sleep 1; echo -n '.'; done
chmod +x /root/install_ocs.sh
wget -O /root/1_create_ns_ocs_pvc.yaml https://raw.githubusercontent.com/mulbc/learn-katacoda/master/persistence/persistent-elasticsearch/assets/1_create_ns_ocs_pvc.yaml
/root/install_ocs.sh