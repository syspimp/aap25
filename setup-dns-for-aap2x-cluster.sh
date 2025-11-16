#!/bin/bash
clustername='compute7-sno'
ip='10.55.102.161'
if [[ -z "$1" || -z "$2" ]]
then
  echo "usage: $0 <openshift clustername> <ip address>"
  echo "example: $0 ${clustername} ${ip}"
  echo
  exit 1
else
  clustername="$1"
  ip="$2"
fi

/opt/dnsupdate.sh "eastcoast-aap25-prod.apps.${clustername}" "${ip}"
/opt/dnsupdate.sh "eastcoast-controller-aap25-prod.apps.${clustername}" "${ip}"
/opt/dnsupdate.sh "eastcoast-hub-aap25-prod.apps.${clustername}" "${ip}"
/opt/dnsupdate.sh "eastcoast-eda-aap25-prod.apps.${clustername}" "${ip}"
/opt/dnsupdate.sh "eastcoast-lightspeed-aap25-prod.apps.${clustername}" "${ip}"

