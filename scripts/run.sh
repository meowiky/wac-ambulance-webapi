#!/usr/bin/env bash

COMMAND=${1:-"start"}

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

export AMBULANCE_API_ENVIRONMENT="Development"
export AMBULANCE_API_PORT="8080"
export AMBULANCE_API_MONGODB_USERNAME="root"
export AMBULANCE_API_MONGODB_PASSWORD="neUhaDnes"

mongo() {
    docker compose --file "${PROJECT_ROOT}/deployments/docker-compose/compose.yaml" "$@"
}

cleanup() {
    mongo down
}

case "$COMMAND" in
    start)
        trap cleanup EXIT
        mongo up --detach
        go run "${PROJECT_ROOT}/cmd/ambulance-api-service"
        ;;
    openapi)
        docker run --rm -ti \
            -v "${PROJECT_ROOT}:/local" \
            openapitools/openapi-generator-cli \
            generate -c /local/scripts/generator-cfg.yaml
        ;;
    test)
        (
            cd "${PROJECT_ROOT}" || exit 1
            go test -v ./...
        )
        ;;
    mongo)
        mongo up
        ;;
    *)
        echo "Unknown command: $COMMAND" >&2
        exit 1
        ;;
esac
