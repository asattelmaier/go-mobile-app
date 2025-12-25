#!/bin/bash
# go-mobile-app/scripts/generate_client.sh

# Ensure script fails on error
set -e

# Configuration
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/../.."
OUTPUT_DIR="$PROJECT_ROOT/packages/session_server_client"
API_FILE="$PROJECT_ROOT/api/session-server-api.json"

echo "=== Session Server Client Generator ==="
echo "Target: $OUTPUT_DIR"

if [ ! -f "$API_FILE" ]; then
    echo "Error: API spec file not found at $API_FILE"
    echo "Please run './scripts/update_api_spec.sh' first (requires running backend)."
    exit 1
fi

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is required to run the OpenAPI generator."
    exit 1
fi

# 2. Generate Client
echo "Generating Dart Client using OpenAPI Generator..."

# Ensure output dir exists
mkdir -p "$OUTPUT_DIR"

GENERATOR_VERSION="v7.8.0"

# Extract version from api-docs.json using python (stripping 'v' prefix for pub compatibility)
CLIENT_VERSION=$(cat "$API_FILE" | python3 -c "import json, sys; print(json.load(sys.stdin)['info']['version'].lstrip('v'))")
echo "Detected API Version: $CLIENT_VERSION"
echo "Using OpenAPI Generator version: $GENERATOR_VERSION"

# Run Generator
# We mount the local api-docs.json and the output directory
docker run --rm \
    -v "$OUTPUT_DIR":/local \
    -v "$API_FILE":/spec.json \
    openapitools/openapi-generator-cli:$GENERATOR_VERSION generate \
    -i /spec.json \
    -g dart \
    -o /local \
    --additional-properties=pubName=session_server_client,pubVersion=$CLIENT_VERSION,datapackage=com.go.client

echo "=== Generation Complete! ==="
echo "You can now depend on this package in 'pubspec.yaml':"
echo "  session_server_client:"
echo "    path: packages/session_server_client"
