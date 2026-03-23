#!/bin/bash

COMMAND=${1:-"start"}

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

export AMBULANCE_API_ENVIRONMENT="Development"
export AMBULANCE_API_PORT="8080"

case "$COMMAND" in
    "start")
        go run "${PROJECT_ROOT}/cmd/ambulance-api-service"
        ;;
    "openapi")
        docker run --rm -it -v "${PROJECT_ROOT}:/local" openapitools/openapi-generator-cli generate -c /local/scripts/generator-cfg.yaml
        ;;
    *)
        echo "Unknown command: $COMMAND"
        exit 1
        ;;
esac