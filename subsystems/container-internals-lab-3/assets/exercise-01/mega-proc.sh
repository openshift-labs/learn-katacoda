#!/bin/bash

ps="ps aux --forest | grep -v grep | grep -v container-processes | grep $f | sed 's/.*/&\n/' | sed 's/\(--[a-zA-Z]*\)/\n\t&/g' | sed 's/\(-[a-zA-Z] .* \)/\n\t&/g' | sed 's/[a-z,0-9]\{30,\}/\n\t&/g'"

case $1 in
docker)
  echo "USER        PID %CPU %MEM VSZ    RSS   TTY      STAT START   TIME COMMAND"
  ps aux --forest \
    | grep -v grep \
    | grep -v openshift \
    | grep -v etcd \
    | grep -v $0 \
    | grep docker \
    | sed 's/.*/&\n/' \
    | sed 's/\(--[a-zA-Z]*\)/\n\t&/g' \
    | sed 's/\(-[a-zA-Z] .* \)/\n\t&/g' \
    | sed 's/[a-z,0-9]\{30,\}/\n\t&/g'
  ;;
openshift)
  echo "USER        PID %CPU %MEM VSZ    RSS   TTY      STAT START   TIME COMMAND"
  ps aux --forest \
    | grep -v grep \
    | grep -v $0 \
    | grep openshift \
    | sed 's/.*/&\n/' \
    | sed 's/\(--[a-zA-Z]*\)/\n\t&/g' \
    | sed 's/\(-[a-zA-Z] .* \)/\n\t&/g' \
    | sed 's/[a-z,0-9]\{30,\}/\n\t&/g'
  ;;
kubernetes)
  echo "USER        PID %CPU %MEM VSZ    RSS   TTY      STAT START   TIME COMMAND"
  ps aux --forest \
    | grep -v grep \
    | grep -v $0 \
    | grep kube \
    | sed 's/.*/&\n/' \
    | sed 's/\(--[a-zA-Z]*\)/\n\t&/g' \
    | sed 's/\(-[a-zA-Z] .* \)/\n\t&/g' \
    | sed 's/[a-z,0-9]\{30,\}/\n\t&/g'
  ;;
*)
  echo "Usage: container-processes {docker|openshift|kubernetes}"
  ;;
esac


