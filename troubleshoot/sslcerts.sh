# !/usr/bin/ev bash

set -euo pipefail
shopt -s expand_aliases

alias k='kubectl'

read -p  "Enter the namespace your Coder deployment is in: " NAMESPACE </dev/tty

main_function(){
    echo "GET PODS"

    k get pods -n $NAMESPACE

    echo "---"
    echo "DESCRIBE INGRESS"

    k describe ingress -n $NAMESPACE

    echo "---"
    echo "DESCRIBE CHALLENGE"

    k describe challenge -A

    echo "---"
    echo "DESCRIBE ORDER"

    k describe order -A
}

# log everything, but also output to stdout
main_function 2>&1 | tee -a output.txt



