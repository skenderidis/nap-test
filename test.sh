#!/bin/bash

# Set the FQDN you want to curl
FQDN="app1.f5k8s.net"

while true; do
  # Get the current timestamp in a readable format
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")

  # Use curl to make a request to the FQDN
  response=$(curl -s -o /dev/null -w "%{http_code}" $FQDN)

  # Check the HTTP response code and output success or failure along with the timestamp
  if [ $response -eq 200 ]; then
    echo "$timestamp - Success! HTTP Status Code: $response"
  else
    echo "$timestamp - Failure! HTTP Status Code: $response"
  fi

  # Sleep for a desired interval before making the next request
  sleep 5  # Adjust the sleep interval as needed
done
