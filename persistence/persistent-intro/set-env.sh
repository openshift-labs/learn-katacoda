launch.sh
until [ -f /root/install_ocs.sh ]; do sleep 1; echo -n '.'; done
chmod +x /root/install_ocs.sh
/root/install_ocs.sh