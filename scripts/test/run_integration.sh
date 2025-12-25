#!/bin/bash

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../.."
COMPOSE_FILE="$PROJECT_ROOT/docker/docker-compose.test.yml"

# Ensure script fails on error
set -e

# Cleanup function
# Cleanup function
dump_logs() {
    if [ -f "/tmp/chrome_debug_log" ]; then
        echo "---------------------------------------------------"
        echo "DUMPING CHROME WRAPPER DEBUG LOG (/tmp/chrome_debug_log):"
        cat "/tmp/chrome_debug_log"
        echo "---------------------------------------------------"
    fi
}

cleanup() {
    echo "Cleaning up..."
    dump_logs
    docker compose -f $COMPOSE_FILE down
}
trap cleanup EXIT

# Start Docker environment (Backend, DB, Gnugo, Chrome)
echo "Starting Docker environment..."
docker compose -f $COMPOSE_FILE up -d --build

# Wait for Backend (mapped to host 8080)
echo "Waiting for Backend (localhost:8080)..."
timeout 120s bash -c 'until curl -s http://localhost:8080/actuator/health > /dev/null; do echo "Waiting for backend..."; sleep 2; done'

# Wait for Chromedriver (mapped/host mode to 4444)
echo "Waiting for Chromedriver (localhost:4444)..."
timeout 30s bash -c 'until curl -s http://localhost:4444/status > /dev/null; do echo "Waiting for chromedriver..."; sleep 1; done'

# Run Integration Tests on Host
# - Using CHROME_EXECUTABLE wrapper to launch Dockerized Chrome
# - Using --dart-define=BACKEND_HOST=localhost (backend is mapped to host port 8080)
export CHROME_EXECUTABLE="$SCRIPT_DIR/chrome_wrapper.sh"
echo "Running Flutter Integration Tests (using $CHROME_EXECUTABLE)..."

TEST_LOG="/tmp/flutter_test_output.$$.log"
touch "$TEST_LOG"

# Run Flutter Drive in background to capture PID
# We pipe to tee for monitoring.
# We CANNOT use process substitution > >(tee) easily if we want $! to be flutter's PID.
# Instead, we will use a named pipe or simple backgrounding with pipe.
# Actually, if we do `cmd | tee &`, $! is the PID of `tee` (or the pipeline job).
# We need the PID of `flutter drive` to send SIGINT.
# Strategy: Run flutter drive in background, redirect output to file, then tail -f file to stdout & monitor.

# Start tailing the log file to stdout (user visibility) in background
tail -f -n +1 "$TEST_LOG" &
TAIL_PID=$!

# Run Flutter Drive, redirecting ALL output to the log file.
# Run Flutter Drive, redirecting ALL output to the log file.
# Increase connection timeout for slow CI runners (default is roughly 30s)
export FLUTTER_WEB_DEVICE_TIMEOUT=60

stdbuf -o0 flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  -d chrome \
  --dart-define=BACKEND_HOST=localhost > "$TEST_LOG" 2>&1 &
FLUTTER_PID=$!

# Background monitor: Watch for "All tests passed!" and send SIGINT to Flutter
    # Monitor the log file for Success OR Failure, with a 10-minute timeout
    START_TIME=$(date +%s)
    TIMEOUT=600 # 10 minutes

    while true; do
        CURRENT_TIME=$(date +%s)
        ELAPSED=$((CURRENT_TIME - START_TIME))
        
        if [ $ELAPSED -gt $TIMEOUT ]; then
             echo "Monitor: Global Timeout (10m) reached. Killing Flutter Drive..."
             kill -INT $FLUTTER_PID 2>/dev/null
             break
        fi

        if grep -qE "All tests passed!|AppConnectionException|Test failed" "$TEST_LOG"; then
            echo "Monitor: Test completion/failure detected. Sending SIGINT to Flutter Drive ($FLUTTER_PID)..."
            kill -INT $FLUTTER_PID 2>/dev/null
            break
        fi
        sleep 2
    done
) &
MONITOR_PID=$!

# Wait for Flutter Drive to finish
wait $FLUTTER_PID
EXIT_CODE=$?

# Stop the tail and monitor
kill $TAIL_PID 2>/dev/null || true
kill $MONITOR_PID 2>/dev/null || true

# Check exit code
# Check exit code
if [ $EXIT_CODE -eq 0 ]; then
    echo "Flutter Drive finished successfully."
else
    echo "Flutter Drive exited with code $EXIT_CODE."
    
    exit $EXIT_CODE
fi
