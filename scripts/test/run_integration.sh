#!/bin/bash
set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../.."
COMPOSE_FILE="$PROJECT_ROOT/docker/docker-compose.test.yml"

echo "=== INTEGRATION TESTS (ALL-IN-DOCKER) ==="

cleanup() {
    echo "Cleaning up Docker resources..."
    docker compose -f $COMPOSE_FILE down
}
trap cleanup EXIT

# 1. Start Infrastructure (Backend, DB, Gnugo)
echo "Starting Backend and Infrastructure..."
docker compose -f $COMPOSE_FILE up -d --build backend

# 2. Wait for Backend Health
echo "Waiting for Backend (localhost:8080 mapped from container)..."
# Since we run tests in docker, 'localhost' here refers to HOST.
# Backend maps 8080:8080, so we can check health from host.
timeout 120s bash -c 'until curl -s http://localhost:8080/actuator/health > /dev/null; do echo "Waiting for backend..."; sleep 2; done'

# 3. Run Tests in Container
# 3. Run Tests in Container
echo "Starting compiled Test Runner (app-test)..."

# We run this in the background and kill it after the test.
# Stream logs from the test runner (Driver outputs responseData directly to stdout)
echo "--- INTEGRATION TEST LOGS ---"
docker compose -f $COMPOSE_FILE logs -f app-test &
LOG_PID=$!

set +e
docker compose -f $COMPOSE_FILE run --rm --build app-test ./scripts/test/run_tests_in_container.sh "$@"
EXIT_CODE=$?
set -e

# Cleanup
kill $LOG_PID || true
echo "Test exited with code $EXIT_CODE"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Tests Passed Successfully!"
else
    echo "❌ Tests Failed with Exit Code $EXIT_CODE"
fi

echo "=== NETWORK BEACON CHECK ==="
echo "Checking backend logs for app signal..."
# We grep for "User data requested" which confirms the app authenticated and hit the API.
if docker compose -f $COMPOSE_FILE logs backend | grep -q "User data requested"; then
    echo "✅ BEACON RECEIVED: App successfully connected to backend!"
else
    echo "❌ BEACON MISSING: App did not contact backend."
    echo "--- BACKEND LOGS DUMP ---"
    docker compose -f $COMPOSE_FILE logs backend
    echo "-------------------------"
fi
echo "============================"

exit $EXIT_CODE
