#!/bin/bash -x
host="https://abc:123@aap25-eu-aap-west.apps.compute7-cluster.tfound.org"
edastream="eda-event-streams/api/eda/v1/external_event_stream/69ccc3cc-b0d6-47d3-8fab-0a29d966a6ce/post/"
msg="test123 from the cmd line"
event="null event"
status="null status"
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
