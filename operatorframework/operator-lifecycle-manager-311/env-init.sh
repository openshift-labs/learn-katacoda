ssh root@host01 'for i in {1..200}; do oc policy add-role-to-user system:image-puller system:anonymous && break || sleep 1; done'
ssh root@host01 'oc adm policy add-cluster-role-to-group sudoer system:authenticated'

#grant the user: developer permissions to push images to the internal registry
ssh root@host01 'oc policy add-role-to-user registry-editor developer --as system:admin'

#Save the existing system:admin .kube/config for up local
ssh root@host01 'mkdir -p ~/backup/.kube'
ssh root@host01 'cp -r ~/.kube/config ~/backup/.kube/'

#Remove the existing ~/.kube/config -> this addresses a untrusted cert issue
#ssh root@host01 'rm -rf ~/.kube/config  >> /dev/null'

ssh root@host01 'yum install jq -y'