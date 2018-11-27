#!/bin/bash

echo "**** Installing ODO using binary file ****"
sudo curl -L https://github.com/redhat-developer/odo/releases/download/v0.0.16/odo-linux-amd64 -o /usr/local/bin/odo && sudo chmod +x /usr/local/bin/odo


