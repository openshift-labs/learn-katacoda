#setup passwordless SSH Keys for User: cent
ssh root@host01 'ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa'
ssh root@host01 'cp /root/.ssh/id_rsa /home/cent/.ssh/'
ssh root@host01 'cp /root/.ssh/id_rsa.pub /home/cent/.ssh/'
ssh root@host01 "cat /home/cent/.ssh/id_rsa.pub >> /home/cent/.ssh/authorized_keys"
ssh root@host01 "chmod og-wx /home/cent/.ssh/authorized_keys"
ssh root@host01 "echo "[[HOST_IP]]  host01" >> /etc/hosts"
ssh root@host01 "ssh-keyscan host01 >> ~/.ssh/known_hosts"
ssh root@host01 "ssh-keyscan [[HOST_IP]] >> ~/.ssh/known_hosts"

ssh root@host01 'yum install jq -y'
