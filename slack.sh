#!/bin/bash
# Run this in your katacoda scenario git repo: https://www.katacoda.community/
# Requires setup of Incoming Webhook on Slack: https://api.slack.com/messaging/webhooks

SCENARIO_URL='https://katacoda.com/btannous/courses/servicemesh/maistra1' 

commit_id=`git log --pretty=format:'%H' -n 1`

echo "Checking if scenario has been updated on Katacoda.."
until curl -s $SCENARIO_URL | grep $commit_id  > /dev/null 2>&1
do
  sleep 15
done

echo $SCENARIO_URL
