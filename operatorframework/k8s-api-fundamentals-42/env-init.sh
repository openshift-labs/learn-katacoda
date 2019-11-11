# grant system:anonymous user the system:image-puller role
for i in {1..200}; do oc policy add-role-to-user system:image-puller system:anonymous && break || sleep 1; done

# grant system:authenticated group the sudoer cluster role
oc adm policy add-cluster-role-to-group sudoer system:authenticated

# grant developer user permissions to push images to the internal registry
oc policy add-role-to-user registry-editor developer --as system:admin

# save the existing system:admin .kube/config for up local
mkdir -p ~/backup/.kube
cp -r ~/.kube/config ~/backup/.kube/

# install jq
yum install jq -y
