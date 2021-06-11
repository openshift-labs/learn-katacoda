#!/bin/bash

# Wait for katacoda to copy our stuff?
while [ ! -f install-ossm.bash ]
do
	sleep 5
done

time bash install-ossm.bash
# Red Hat OpenShift Service Mesh installed.
