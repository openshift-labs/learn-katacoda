#!/bin/bash
# This is the script to put provisioning things in, this runs in the foreground
set -o pipefail
cd /root/helm
mkdir -p /root/helm/my-chart/charts
clear
echo "Helm Tutorial Ready!" 