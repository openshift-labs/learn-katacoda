ssh root@host01 'oc apply -f https://raw.githubusercontent.com/btannous/learn-katacoda/serverless/introduction/serverless/assets/operator-subscription.yaml'
ssh root@host01 'for i in {1..200}; do oc policy add-role-to-user system:image-puller system:anonymous && break || sleep 1; done'
ssh root@host01 'oc adm policy add-cluster-role-to-group sudoer system:authenticated'

echo "Ready"
