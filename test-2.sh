#!/bin/bash

if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <file>"
  exit 1
fi

#FQDN="$1"
FQDN="app1.f5k8s.net"

timestamp=$(date "+%Y-%m-%d %H:%M:%S")
echo $timestamp
kubectl apply -f $1

# Sleep 1 second for NGINX to pick up the changes.
sleep 1

# Initialize the counter
initial_deploy=0

while true; do
  # Increment the counter
  ((initial_deploy++))

  # Get the current timestamp in a readable format
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")

  # Use curl to make a request to the FQDN
  response=$(curl -iLs $FQDN/ | grep "^HTTP\/")

  # Check the HTTP response code and output success or failure along with the timestamp
  if [[ "$response" == *200* ]]; then
    # Log success message
    echo "$timestamp - $FQDN - *****Success**** - ! : $response"
    break  # Exit the while loop
  else
    # Log error code and message
    echo "$timestamp - $FQDN - $response "
  fi

  # Sleep for 1 second
  sleep 1  
done


timestamp=$(date "+%Y-%m-%d %H:%M:%S")
echo $timestamp

kubectl apply -f new_app.yaml

# Sleep for 1 second
sleep 1  

# Initialize the counter
new_deploy=0
FQDN="app600.f5k8s.net"

while true; do
  # Increment the counter
  ((new_deploy++))

  # Get the current timestamp in a readable format
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")

  # Use curl to make a request to the FQDN
  response=$(curl -iLs $FQDN | grep "^HTTP\/")

  # Check the HTTP response code and output success or failure along with the timestamp
  if [[ "$response" == *200* ]]; then
    # Log success message
    echo "$timestamp - $FQDN - *****Success**** - ! : $response"
    break  # Exit the while loop
  else
    # Log error code and message
    echo "$timestamp - $FQDN - $response "
  fi

  # Sleep for 1 second
  sleep 1  
done

timestamp=$(date "+%Y-%m-%d %H:%M:%S")
echo $timestamp

kubectl apply -f new_app_with_nap.yaml

# Sleep for 1 second
sleep 1  

# Initialize the counter
new_deploy_with_nap=0
FQDN="app500.f5k8s.net"

while true; do
  # Increment the counter
  ((new_deploy_with_nap++))

  # Get the current timestamp in a readable format
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")

  # Use curl to make a request to the FQDN
  response=$(curl -iLs $FQDN/ | grep "^HTTP\/")

  # Check the HTTP response code and output success or failure along with the timestamp
  if [[ "$response" == *200* ]]; then
    # Log success message
    echo "$timestamp - $FQDN - *****Success**** - ! : $response"
    break  # Exit the while loop
  else
    # Log error code and message
    echo "$timestamp - $FQDN - $response "
  fi

  # Sleep for 1 second
  sleep 1  
done

echo "********* Results **********"

echo "Time to deploy $1 policy with NAP: $initial_deploy seconds" 
echo "Time to deploy 1 additional Ingress policy: $new_deploy seconds"
echo "Time to deploy 1 additional Ingress policy with NAP: $new_deploy_with_nap seconds"



echo "********* End of Tests **********"
