# !/usr/bin/ev bash

set -euo pipefail
shopt -s expand_aliases

FILE="coder-output.txt"
alias k='kubectl'

echo "Enter the namespace your Coder deployment is in:"

read NAMESPACE

echo "---" > $FILE
echo "GET PODS" >> $FILE

k get pods -n $NAMESPACE >> $FILE

echo "---" >> $FILE
echo "DESCRIBE INGRESS" >> $FILE

k describe ingress -n $NAMESPACE >> $FILE

echo "---" >> $FILE
echo "GET CERT-MANAGER SECRETS" >> $FILE

k get secrets -n cert-manager >> $FILE

echo "---" >> $FILE

CHECK=$(k get order,challenge)
SUB='No resources'

if [[ "$CHECK" == *"$SUB"* ]]; then
    :
else
    echo "DESCRIBE CHALLENGE" >> $FILE
    k describe challenge -A >> $FILE
    echo "DESCRIBE ORDER" >> $FILE
    k describe order -A >> $FILE
fi



