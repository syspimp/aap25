#!/bin/bash -x
host="https://abc:123@aap25-gw.tfound.org"
#host="https://abc:123@eastcoast-aap25-prod.apps.compute7-cluster.tfound.org"
edastream="eda-event-streams/api/eda/v1/external_event_stream/7cece50c-dfc6-497d-8a38-d052159fd00e/post/"
#edastream="eda-event-streams/api/eda/v1/external_event_stream/7662fe74-6177-4bad-945e-41d2242fc659/post/"
msg="test123 from the cmd line"
event="this is the event field"
status="this is the status field"
if [[ ! -z "$1" ]]
then
  event="$1"
fi

if [[ ! -z "$2" ]]
then
  status="$2"
fi

if [[ ! -z "$3" ]]
then
  msg="$3"
fi
curl -k\
	--header "Content-Type: application/json" \
	--request POST \
	--data '{"webhook_event": "'"${event}"'", "status": "'"${status}"'", "message": "'"${msg}"'"}' \
	${host}/${edastream}
