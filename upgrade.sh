# !/usr/bin/env bash

# NAME: upgrade.sh - intended for automating Coder's upgrade process, as referenced
# here: https://coder.com/docs/setup/updating. Requires setting the NAMESPACE & VERSION
# variables in order to run properly.

set -euo pipefail

function prerequisites() {
    # check if Coder helm repo is added
    LIST_INPUT=$(helm repo list)

    # if the above doesn't return this value, run helm repo add
    if [ "$LIST_INPUT" != "NAME URL coder https://helm.coder.com" ]; then
        helm repo add coder https://helm.coder.com
    fi
}

function ugrade() {
    # retrieve latest repository information
    helm repo update

    # upgrade to desired version
    helm upgrade --namespace $NAMESPACE --force --install --atomic --wait \
    --version $VERSION coder coder/coder
}

function usage() {
    echo "Usage: set NAMESPACE and VERSION variables before running. VERSION format should follow x.xx.x"
    exit 1
}

# return usage if namespace is blank or version doesn't match the version format.
if [[ "$NAMESPACE" == "" || "$VERSION" !=~ ^[0-9]\.[0-9]\.[0-9]$ ]]; then
    usage
fi

function main() {
    prerequisites
    upgrade
}

main