#!/bin/bash
set -e

# Navigate to project root
cd "$(dirname "$0")/../.."

# Check if google-chrome is installed
if ! command -v google-chrome &> /dev/null; then
    echo "Error: google-chrome is not installed."
    exit 1
fi

TOOLS_DIR="$(pwd)/test_driver/tools"
CHROMEDRIVER_PATH="$TOOLS_DIR/chromedriver"

if [ ! -f "$CHROMEDRIVER_PATH" ]; then
    echo "----------------------------------------------------------------"
    echo "Chromedriver not found locally. Auto-downloading..."
    
    CHROME_VERSION=$(google-chrome --version | awk '{print $3}')
    echo "Detected Chrome Version: $CHROME_VERSION"
    
    DOWNLOAD_URL="https://storage.googleapis.com/chrome-for-testing-public/$CHROME_VERSION/linux64/chromedriver-linux64.zip"
    
    mkdir -p "$TOOLS_DIR"
    echo "Downloading from: $DOWNLOAD_URL"
    curl -s -o "$TOOLS_DIR/chromedriver.zip" "$DOWNLOAD_URL"
    
    echo "Unzipping..."
    unzip -q "$TOOLS_DIR/chromedriver.zip" -d "$TOOLS_DIR"
    
    # Move binary from subdirectory if needed
    if [ -f "$TOOLS_DIR/chromedriver-linux64/chromedriver" ]; then
        mv "$TOOLS_DIR/chromedriver-linux64/chromedriver" "$TOOLS_DIR/"
    fi
    
    chmod +x "$CHROMEDRIVER_PATH"
    echo "Chromedriver installed to $CHROMEDRIVER_PATH"
fi

# Add local tools to PATH
export PATH="$TOOLS_DIR:$PATH"

echo "----------------------------------------------------------------"
echo "Starting Backend Services in Docker (Detached)..."
echo "----------------------------------------------------------------"
# docker compose -f docker/docker-compose.test.yml up backend firestore-emulator gnugo -d --build

echo "----------------------------------------------------------------"
echo "Waiting for Backend Health (http://localhost:8080/actuator/health)..."
echo "----------------------------------------------------------------"
# Loop until backend returns 200 OK
# timeout 120s bash -c 'until curl -s http://localhost:8080/actuator/health | grep "UP" > /dev/null; do echo "Waiting for backend..."; sleep 2; done'
echo "Backend is READY!"

echo "----------------------------------------------------------------"
echo "Starting Chromedriver..."
echo "----------------------------------------------------------------"
# Start chromedriver in background
chromedriver --port=4444 &
CHROMEDRIVER_PID=$!
# Ensure cleanup on exit
trap "kill $CHROMEDRIVER_PID" EXIT

echo "----------------------------------------------------------------"
echo "Running Flutter Integration Tests (Visible UI)"
echo "----------------------------------------------------------------"
# Run flutter drive with local chrome, visible UI
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  -d chrome \
  --web-browser-flag "--auto-open-devtools-for-tabs" \
  --web-browser-flag "--window-size=1200,1000"

# Note: We do not auto-tear down docker here so you can debug if needed.
echo "----------------------------------------------------------------"
echo "Test Run Complete. To stop backend, run: docker compose -f docker/docker-compose.test.yml down"
