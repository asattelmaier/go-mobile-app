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

# PROBE: Verify environment state
which stdbuf || echo "❌ stdbuf NOT FOUND"
echo "--- DEBUG: app_test.dart content ---"
head -n 20 integration_test/app_test.dart
echo "------------------------------------"



# PERFORMANCE FIX 2: Silent Chromedriver (Noise Reduction)
# We rely on Remote Logger (via Backend) for app logs, so we don't need verbose driver logs.
chromedriver --port=4444 --whitelisted-ips="" --silent &
DRIVER_PID=$!
echo "Chromedriver started (PID: $DRIVER_PID)"

# 3. Wait for Port 4444
echo "Waiting for Chromedriver..."
MAX_RETRIES=20
COUNT=0
while [ $COUNT -lt $MAX_RETRIES ]; do
    # check if port is open using netstat or just wait and rely on retry
    # simplified check since we are silent:
    sleep 0.5
    COUNT=$((COUNT+1))
done

# PERFORMANCE FIX 3: "Turbo Mode" - No Pub, Basic Password Store
# Removed --disable-software-rasterizer based on user feedback to avoid rendering conflicts.
# Removed --disable-gpu and --password-store from top-level flutter drive (invalid).
FLUTTER_DRIVE_FLAGS="--no-pub"

echo "Executing: flutter drive $FLUTTER_DRIVE_FLAGS (release)"
# 4. Run Tests
echo "Running Flutter Drive..."
set +e
TARGET=${1:-integration_test/app_test.dart}
echo "Targeting: $TARGET"

# 2. Run Integration Tests
echo "--- RUNNING INTEGRATION TESTS ---"
# Log Streaming: Unbuffer output (stdbuf) to see logs in real-time
stdbuf -oL -eL flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  --browser-name=chrome \
  -d chrome \
  --release \
  $FLUTTER_DRIVE_FLAGS \
  --web-hostname=127.0.0.1 \
  --dart-define=BACKEND_HOST=$HOST \
  --dart-define=FLUTTER_WEB_RENDERER=html \
  --web-browser-flag "--headless=new" \
  --web-browser-flag "--no-sandbox" \
  --web-browser-flag "--disable-dev-shm-usage" \
  --web-browser-flag "--disable-extensions" \
  --web-browser-flag "--window-size=1920,1080" \
  2>&1 | tee "$FLUTTER_LOG" &
FLUTTER_PID=$!

wait $FLUTTER_PID
EXIT_CODE=$?

# Give sidecar a moment to flush remaining logs
sleep 1
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
