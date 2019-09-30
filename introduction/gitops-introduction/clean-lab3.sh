#!/bin/bash
stty -echo
export PS1=""
clear

ARGOCD_REPOSITORY=$(argocd repo list -o url | grep gitops-lab.git)

if [ "0$(echo ${ARGOCD_REPOSITORY} | grep -c gitops-lab.git)" -eq "01" ]
then
  argocd repo rm "${ARGOCD_REPOSITORY}"
else
  echo "Repository not found"
fi

sleep 3

ARGOCD_APP=$(argocd app list -o name | grep reverse-words-app)

if [ "0$(echo ${ARGOCD_APP} | grep -c reverse-words-app)" -eq "01" ]
then
  argocd app delete "${ARGOCD_APP}" --cascade
else
  echo "App not found"
fi

export PS1="$ "
stty echo
