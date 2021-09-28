#!/bin/bash

gh auth login --web
gh repo fork openshift-katacoda/rhoar-getting-started --clone=false
gh auth logout