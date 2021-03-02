# !/usr/bin/env bash
set -euo pipefail

helm uninstall coder

kubectl get all,pvc,networkpolicy,secrets -l com.coder.resource=true -o name | xargs kubectl delete --force --grace-period=0