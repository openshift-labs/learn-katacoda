#setup passwordless SSH Keys for User: cent
ssh root@host01 'ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa'
ssh root@host01 'cp /root/.ssh/id* /home/cent/.ssh/'
ssh root@host01 "cat /home/cent/.ssh/id_rsa.pub >> /home/cent/.ssh/authorized_keys"
ssh root@host01 "chmod og-wx /home/cent/.ssh/authorized_keys"
ssh root@host01 "echo "[[HOST_IP]]  host01" >> /etc/hosts"
ssh root@host01 "ssh-keyscan host01 >> ~/.ssh/known_hosts"
ssh root@host01 "ssh-keyscan [[HOST_IP]] >> ~/.ssh/known_hosts"

#install latest version of ansible
ssh root@host01 'yum install epel-release -y'
ssh root@host01 'yum install ansible -y'

#install openshift client
ssh root@host01 'yum install python-pip -y'
ssh root@host01 'pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org --upgrade pip'
ssh root@host01 'pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org --upgrade setuptools'
ssh root@host01 'pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org --ignore-installed ipaddress openshift'

ssh root@host01 'yum install jq -y'