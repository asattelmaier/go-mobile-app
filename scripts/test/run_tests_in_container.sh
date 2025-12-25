#!/bin/bash
set -e

echo "=== INTEGRATION TESTS (MANUAL DRIVER STRATEGY) ==="

# SAFETY GUARD: Ensure this script is running inside Docker
if [ ! -f "/.dockerenv" ]; then
    echo "❌ ERROR: This script must be run INSIDE the Docker container."
    echo "   Do NOT run this directly on your host machine."
    echo "   Use this command instead:"
    echo "   ./scripts/test/run_integration.sh"
    exit 1
fi
HOST=${BACKEND_HOST:-backend}

# PERFORMANCE FIX 1: Prevent DBus timeouts by redirecting system calls
export DBUS_SESSION_BUS_ADDRESS=/dev/null
flutter pub get

# 1. Setup Environment
# CHROME_EXECUTABLE is set in Dockerfile, but we confirm it here.
echo "Using Chrome Executable: $CHROME_EXECUTABLE"
$CHROME_EXECUTABLE --version

# LOGGING SETUP: Write logs to a mounted volume for artifacts
LOG_DIR="/app/test_logs"
mkdir -p "$LOG_DIR"
CHROMEDRIVER_LOG="$LOG_DIR/chromedriver.log"
FLUTTER_LOG="$LOG_DIR/flutter_drive.log"

# 2. Start Chromedriver
echo "Starting Chromedriver..."
pkill chromedriver || true
# PERFORMANCE FIX 2: "--silent" prevents massive I/O lag from tracing logs
chromedriver --port=4444 --whitelisted-ips="" --silent &
DRIVER_PID=$!
echo "Chromedriver started (PID: $DRIVER_PID)"

# 3. Wait for Port 4444
echo "Waiting for Chromedriver..."
MAX_RETRIES=20
COUNT=0
while [ $COUNT -lt $MAX_RETRIES ]; do
    if grep -q "Port 4444 is being used" "$CHROMEDRIVER_LOG" || grep -q "listening on" "$CHROMEDRIVER_LOG"; then
        echo "Chromedriver is listening."
        break
    fi
    sleep 0.5
    COUNT=$((COUNT+1))
done

# 4. Run Tests
echo "Running Flutter Drive..."
set +e
TARGET=${1:-integration_test/app_test.dart}
echo "Targeting: $TARGET"



# PERFORMANCE FIX 3: "Turbo Mode" - No Pub, Disable GPU/Exts, Basic Password Store
# Note: Removed stdbuf temporarily to debug 'ml' syntax error.
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=$TARGET \
  --browser-name=chrome \
  -d chrome \
  --release \
  --no-pub \
  --web-hostname=127.0.0.1 \
  --dart-define=BACKEND_HOST=$HOST \
  --dart-define=FLUTTER_WEB_RENDERER=html \
  --web-browser-flag "--headless=new" \
  --web-browser-flag "--no-sandbox" \
  --web-browser-flag "--disable-dev-shm-usage" \
  --web-browser-flag "--disable-gpu" \
  --web-browser-flag "--disable-software-rasterizer" \
  --web-browser-flag "--disable-extensions" \
  --web-browser-flag "--window-size=1920,1080" \
  --web-browser-flag "--password-store=basic" \
  --web-browser-flag "--use-mock-keychain" \
  -v 2>&1 | tee "$FLUTTER_LOG"

EXIT_CODE=$?
echo "Flutter Drive exited with code $EXIT_CODE"

# FINAL VERIFICATION: Truth is in the logs
# FINAL VERIFICATION: Truth is in the logs
if grep -aq "All tests passed" "$FLUTTER_LOG"; then
    echo "SUCCESS: Tests passed (verified via logs)."
    EXIT_CODE=0
else
    echo "FAILURE: 'All tests passed!' not found in logs."
    echo "Check $FLUTTER_LOG for 'AppConnectionException' or other errors."
    
    echo "--- LOG DEBUG INFO ---"
    ls -l "$FLUTTER_LOG"
    echo "--- HEAD ---"
    head -n 5 "$FLUTTER_LOG"
    echo "--- TAIL ---"
    tail -n 20 "$FLUTTER_LOG"
    echo "--- END LOG DEBUG ---"
    
    EXIT_CODE=1
fi

if [ $EXIT_CODE -ne 0 ]; then
    echo "--- Chromedriver Log (Tail) ---"
    tail -n 50 "$CHROMEDRIVER_LOG"
    echo "--- Flutter Drive Log (Tail) ---"
    tail -n 100 "$FLUTTER_LOG"
fi


kill $DRIVER_PID || true
echo "DEBUG: Exiting run_tests_in_container.sh with code $EXIT_CODE"
exit $EXIT_CODE
