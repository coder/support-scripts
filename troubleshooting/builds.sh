# !/usr/bin/ev bash

set -euo pipefail
shopt -s expand_aliases

alias k='kubectl'

read -p  "Enter the namespace your Coder deployment is in: " NAMESPACE </dev/tty

k get pods -n $NAMESPACE

read -p "Select the pod you'd like to debug: " POD </dev/tty

main_function(){

    echo "Getting $POD logs..."

    k logs $POD -n $NAMESPACE

    k logs deploy/cemanager -n $NAMESPACE

}

# log everything, but also output to stdout
main_function 2>&1 | tee -a ssl_output.txt



