# !/usr/bin/env bash

# NAME: upgrade.sh - intended for automating Coder's upgrade process, as referenced
# here: https://coder.com/docs/setup/updating. Requires setting the NAMESPACE variable
# in order to run properly. The VERSION variable can be omitted. If set, it must follow
# a specific format (x.x.x or x.xx.x).

set -euo pipefail

echo "Enter namespace:"

read NAMESPACE

echo "Enter version #"

read VERSION

function prerequisites() {
    # check if Coder helm repo is added
    LIST_INPUT=$(helm repo list)

    # if the above doesn't return this value, run helm repo add
    if [ "$LIST_INPUT" != *"https://helm.coder.com"* ]; then
        helm repo add coder https://helm.coder.com
    fi
}

function upgrade() {
# retrieve latest repository information
    helm repo update

# upgrade to desired version - if VERSION doesn't exist, 
# run upgrade command with VERSION omitted (default to latest).
   if [ "$VERSION" == "" ]; then
        helm upgrade --namespace $NAMESPACE --force --install --atomic --wait \
        coder coder/coder
   else
        helm upgrade --namespace $NAMESPACE --force --install --atomic --wait \
        --version $VERSION coder coder/coder
    fi
}

function usage() {
    echo "Usage: set NAMESPACE and VERSION variables before running. 
    VERSION format should follow x.xx.x. Omitting VERSION will default to latest."
    exit 1
}

# return usage if NAMESPACE is blank or VERSION doesn't match the correct format.
    if [[ "$VERSION" != "" && ! "$VERSION" =~ ^([0-9]\.([1-9]|[1-9][0-9])\.[0-9])$ || "$NAMESPACE" == "" ]]; then
        usage
    fi

function main() {
    prerequisites
    upgrade

    if [ $? -eq 0 ]; then
        echo "Upgrade successful."
    else
        echo "Upgrade failed. Please reference our documentation for troubleshooting
        a failed upgrade https://coder.com/docs/setup/updating#fixing-a-failed-upgrade."
}

main