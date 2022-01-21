#!/bin/bash

set -Eeuo pipefail
echo "TEST 1"
API_ADDR=$(terraform output -json |jq -r '."fqdn"."value"')
echo "TEST 1"
echo $API_ADDR
# Basic health check endpoint
curl -sSf -o /dev/null --retry 10 --retry-connrefused http://${API_ADDR}/healthz
echo "TEST 2"
# External API
curl -sSf -o /dev/null --retry 10 --retry-connrefused http://${API_ADDR}/v2/status
curl -sSf -o /dev/null --retry 10 --retry-connrefused http://${API_ADDR}/v3/status
echo "TEST 3"
# Internal API (peers)
curl -sSf -o /dev/null --retry 10 --retry-connrefused http://${API_ADDR}/v2/debug/peers
curl -sSf -o /dev/null --retry 10 --retry-connrefused http://${API_ADDR}/v3/debug/peers
echo "TEST 4"
# Internal API (pending transactions)
curl -sSf -o /dev/null --retry 10 --retry-connrefused http://${API_ADDR}/v2/debug/transactions/pending
curl -sSf -o /dev/null --retry 10 --retry-connrefused http://${API_ADDR}/v3/debug/transactions/pending
echo "TEST 5"
# Internal API (dry-run)
EXT_STATUS=$(curl -sS -o /dev/null --retry 10 --retry-connrefused \
    -X POST -H 'Content-type: application/json' -d '{}' \
    -w "%{http_code}" \
    http://${API_ADDR}/v2/debug/transactions/dry-run)
[ $EXT_STATUS -eq 400 ]
echo "TEST 6"
EXT_STATUS=$(curl -sS -o /dev/null --retry 10 --retry-connrefused \
    -X POST -H 'Content-type: application/json' -d '{}' \
    -w "%{http_code}" \
    http://${API_ADDR}/v3/debug/transactions/dry-run)
[ $EXT_STATUS -eq 400 ]
echo "TEST 7"
# Temporary disabled - https://github.com/aeternity/aeternity/issues/3131
# State Channels WebSocket API
# WS_STATUS=$(curl -sS -o /dev/null --retry 10 --retry-connrefused \
#     -w "%{http_code}" \
#     http://${API_ADDR}/channel)
# [ $WS_STATUS -eq 426 ]
