ssh root@host01 'oc apply -f https://raw.githubusercontent.com/btannous/learn-katacoda/serverless/introduction/serverless/assets/operator-subscription.yaml'
# TODO might need to wait before running these below for the operators to come up?
ssh root@host01 'oc apply -f https://raw.githubusercontent.com/btannous/learn-katacoda/serverless/introduction/serverless/assets/serving.yaml'
ssh root@host01 '0c apply -f https://raw.githubusercontent.com/btannous/learn-katacoda/serverless/introduction/serverless/assets/eventing.yaml'
ssh root@host01 'for i in {1..200}; do oc policy add-role-to-user system:image-puller system:anonymous && break || sleep 1; done'
ssh root@host01 'oc adm policy add-cluster-role-to-group sudoer system:authenticated'

echo "Ready"
