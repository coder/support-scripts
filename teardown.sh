# !/usr/bin/env bash

# NAME: teardown.sh - uninstalls Coder & deletes assocated resources, while keeping the
# namespace & cluster intact, in order to preserve a possible re-install. if you need to
# tear down Coder & its cluster, navigate to https://coder.com/docs/guides/teardown for instructions.

set -euo pipefail

# uninstalls all coder-related services in the cluster -
# does not delete user environments or their assocated PVCs.

function uninstall_coder() {
    helm uninstall coder
}

# gets all resources with the label of com.coder.resource
# and deletes them from the cluster.

function delete_resources() {
    kubectl get all,pvc,networkpolicy,secrets -l com.coder.resource=true -o name |
    xargs kubectl delete --force --grace-period=0
}

function usage() {
    echo "Usage: Please set the NAMESPACE variable to the namespace Coder is deployed in."
}

# if NAMESPACE variable isn't set, return usage.
if [[ "$NAMESPACE" == "" ]]; then
    usage
fi

kubectl config set-context --current --namespace=$NAMESPACE

function main() {
    uninstall_coder
    delete_resources
    kubectl delete pvc -l app=timescale --grace-period=0 --force
}

main