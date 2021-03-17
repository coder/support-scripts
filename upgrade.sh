# !/usr/bin/env bash

# NAME: upgrade.sh - intended for automating Coder's upgrade process, as referenced
# here: https://coder.com/docs/setup/updating. Requires setting the NAMESPACE variable
# in order to run properly. The VERSION variable can be omitted. If set, it must follow
# a specific format (x.x.x or x.xx.x).

set -euo pipefail

echo "Enter the namespace your Coder deployment is in:"

read NAMESPACE

echo "Enter version you'd like to upgrade to"

read VERSION

# check if --fix flag exists. if so, then run --fix commands.
if [ $# -ne 0 ]; then
    while [ $# -ne 0 ]; do
        case "$1" in
            --fix)
                echo "Attempting to fix your failed upgrade..."
                echo "Exporting your helm chart values into a file > tmp/current-values.yml..."
                mkdir tmp && helm get values --namespace $NAMESPACE coder > tmp/current-values.yml
                echo "Uninstalling Coder..."
                helm uninstall --namespace $NAMESPACE coder
                echo "Waiting for all resources to delete..."
                sleep 25
                helm upgrade --namespace $NAMESPACE --atomic \
                --wait --install --force --version $VERSION \
                coder coder/coder --values tmp/current-values.yml   

                exit >&2         
        esac
    done
    # if flag exists, then do not run the below.
    else {
        function prerequisites() {
        # check if Coder helm repo is added, if not, add coder helm repo
            if helm repo list | grep -q "https://helm.coder.com"; then
                echo "Coder already exists within the current helm config."
            else
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

                if upgrade; then
                    echo "\n\nUpgrade successful."
                else
                    echo "\n\nUpgrade failed. Please reference our documentation for troubleshooting
                    a failed upgrade https://coder.com/docs/setup/updating#fixing-a-failed-upgrade. 
                    Alternatively, run ./upgrade.sh --fix to attempt the commands automatically."
                fi
                }
            main
        }
fi

