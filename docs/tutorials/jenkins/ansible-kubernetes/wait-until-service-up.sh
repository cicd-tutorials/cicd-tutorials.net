#!/bin/sh -xe

get_hostname() {
  kubectl get service animals -o json | \
    jq -re .status.loadBalancer.ingress[0].hostname
}

# Wait until hostname is available
until get_hostname; do
  sleep 15;
done;

# Wait until animals application is up
hostname=$(get_hostname)
until curl -sSf $hostname; do
  sleep 15;
done;

echo "Load-balancer URL: $hostname"
