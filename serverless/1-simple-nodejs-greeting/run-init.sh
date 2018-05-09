#!/bin/bash
ssh root@host01 "rm -rf /root/projects"
ssh root@host01 "rm -rf /root/temp-pom.xml"
ssh root@host01 "mkdir -p /root/projects/ocf && mkdir -p /root/openwhisk/bin/"
