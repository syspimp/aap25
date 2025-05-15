#!/bin/bash
curl \
	--header "Content-Type: application/json" \
	--request POST \
	--data '{"log_status": true, "message": "test123"}' \
	localhost:5000
