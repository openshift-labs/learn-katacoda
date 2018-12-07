ssh root@host01 'for i in {1..200}; do oc policy add-role-to-user system:image-puller system:anonymous && break || sleep 1; done'
ssh root@host01 'oc adm policy add-cluster-role-to-group sudoer system:authenticated'
# ssh root@host01 "mkdir -p /data/pv-01 /data/pv-02 /data/pv-03"
# ssh root@host01 "chmod 0777 /data/pv-*; chcon -t svirt_sandbox_file_t /data/pv-*;"
# ssh root@host01 "oc create -f volumes.json --as system:admin"
ssh root@host01 "docker pull registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:latest"
# #ssh root@host01 "oc apply -f https://gist.githubusercontent.com/jorgemoralespou/033c27a354406d7c5111711346e79b01/raw/000e26a7e736313716e46a11a710fbe2c0cbb791/java-is-insecure.json -n openshift --as system:admin"
# ssh root@host01 "oc import-image -n openshift java 1> /dev/null --as system:admin"
# ssh root@host01 "oc import-image -n openshift nodejs 1> /dev/null --as system:admin"
echo "Ready"
