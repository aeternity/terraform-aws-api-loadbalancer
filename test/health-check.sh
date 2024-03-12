#!/bin/bash

set -Eeuo pipefail
API_ADDR=$(terraform output -json |jq -r '."fqdn"."value"')
echo $API_ADDR
# Basic health check endpoint
echo "Basic health check endpoint"
curl -sSf -o /dev/null --retry 10 --retry-connrefused http://${API_ADDR}/healthz
echo "External api"
# External API
curl -sSf -o /dev/null --retry 10 --retry-connrefused http://${API_ADDR}/v3/status
echo "Internal API (peers)"
# Internal API (peers)
curl -sSf -o /dev/null --retry 10 --retry-connrefused http://${API_ADDR}/v3/debug/peers
echo "Internal API (pending transactions)"
# Internal API (pending transactions)
curl -sSf -o /dev/null --retry 10 --retry-connrefused http://${API_ADDR}/v3/debug/transactions/pending
echo "Internal API (dry-run)"
# Internal API (dry-run)
EXT_STATUS=$(curl -sS -o /dev/null --retry 10 --retry-connrefused \
    -X POST -H 'Content-type: application/json' -d '{}' \
    -w "%{http_code}" \
    http://${API_ADDR}/v3/debug/transactions/dry-run)
[ $EXT_STATUS -eq 400 ]

EXT_STATUS=$(curl -sS -o /dev/null --retry 10 --retry-connrefused \
    -X POST -H 'Content-type: application/json' -d '{}' \
    -w "%{http_code}" \
    http://${API_ADDR}/v3/debug/transactions/dry-run)
[ $EXT_STATUS -eq 400 ]

# Temporary disabled - https://github.com/aeternity/aeternity/issues/3131
# State Channels WebSocket API
# WS_STATUS=$(curl -sS -o /dev/null --retry 10 --retry-connrefused \
#     -w "%{http_code}" \
#     http://${API_ADDR}/channel)
# [ $WS_STATUS -eq 426 ]
