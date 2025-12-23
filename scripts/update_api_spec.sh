#!/bin/bash
# go-mobile-app/scripts/update_api_spec.sh

# Ensure script fails on error
set -e

# Configuration
# Default to local server if not provided as argument
SERVER_URL="${1:-http://127.0.0.1:8080}"
API_DOCS_PATH="/v3/api-docs"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
API_FILE="$SCRIPT_DIR/../api/session-server-api.json"

echo "=== Update API Spec ==="

# Ensure target directory exists
mkdir -p "$(dirname "$API_FILE")"

# 1. Fetch API Spec (and format it)
echo "Fetching API Spec from $SERVER_URL$API_DOCS_PATH..."

# Fetch to temp file
TEMP_FILE="${API_FILE}.tmp"
curl -s -o "$TEMP_FILE" "$SERVER_URL$API_DOCS_PATH"

if [ ! -s "$TEMP_FILE" ] || grep -q "Connection refused" "$TEMP_FILE"; then
    echo "Error: Could not fetch API spec. Is the 'go-session-server' running on port 8080?"
    echo "Please start the backend first: ./mvnw spring-boot:run"
    rm -f "$TEMP_FILE"
    exit 1
fi

# Format JSON
cat "$TEMP_FILE" | python3 -m json.tool --indent 2 > "$API_FILE"
rm "$TEMP_FILE"

echo "Success! API spec updated (and formatted) at $API_FILE"
