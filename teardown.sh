# !/usr/bin/env bash

#/ NAME:
#/ teardown.sh - Uninstalls Coder & deletes assocated resources, while keeping the-
#/ namespace & cluster intact, in order to preserve a possible re-install.

set -euo pipefail

#/ Uninstalls all coder-related services in the cluster. 
#/ Does not delete user environments or their assocated PVCs.

function uninstall_coder() {
    helm uninstall coder
}

#/ Gets all resources with the label of com.coder.resource
#/ and deletes them from the cluster.

function delete_resources() {
    kubectl get all,pvc,networkpolicy,secrets -l com.coder.resource=true -o name | 
    xargs kubectl delete --force --grace-period=0
}

function main() {
    uninstall_coder
    delete_resources
}

main