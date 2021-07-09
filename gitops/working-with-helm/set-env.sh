#!/bin/bash

#
## Wait until the file exists before running it
until [ -f resources/scripts/argocd-postinstall.sh ]
do
    sleep 5
done

#
## Launch the script that sets up ArgoCD with customizations
bash resources/scripts/argocd-postinstall.sh
##
##