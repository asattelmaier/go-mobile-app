#!/bin/bash
# Wrapper to run google-chrome inside the docker container
# Flutter on host calls this. We forward call to docker.

DEBUG_LOG="/tmp/chrome_debug_log"
echo "DEBUG $(date +%H:%M:%S): Wrapper started with args: $@" > "$DEBUG_LOG"

# Check if container is running
if [ -z "$(docker ps -q -f name=docker-headless-chrome)" ]; then
    echo "Error: docker-headless-chrome container is not running." >&2
    echo "DEBUG $(date +%H:%M:%S): Error - Container not running" >> "$DEBUG_LOG"
    exit 1
fi

# Ensure .chrome_home structure exists on host
HOST_CHROME_HOME=".chrome_home"
CONTAINER_CHROME_HOME="/app/.chrome_home"
mkdir -p "$HOST_CHROME_HOME"

# Clean up stale locks
if [ -f "$HOST_CHROME_HOME/chrome_profile/SingletonLock" ]; then
    rm -f "$HOST_CHROME_HOME/chrome_profile/SingletonLock"
fi

# Filter arguments to replace --user-data-dir
ARGS=()
for arg in "$@"; do
  if [[ "$arg" == --user-data-dir=* ]]; then
    continue
  fi
  ARGS+=("$arg")
done

CONTAINER_PROFILE_DIR="$CONTAINER_CHROME_HOME/chrome_profile"

# Cleanup handler
cleanup() {
  if [ -n "$PID" ]; then
    kill $PID 2>/dev/null
  fi
  exit 0
}
trap 'cleanup' SIGTERM SIGINT SIGHUP

# Construct command
FLAGS="--user-data-dir=$CONTAINER_PROFILE_DIR --no-sandbox --disable-dev-shm-usage --headless --disable-gpu --disable-software-rasterizer --remote-allow-origins=*"
# CMD: Run Chrome, merge stdout/stderr, filter for URL/Version (unbuffered), and wait.
# Filtering INSIDE container (at source) is safer than filtering the tail stream on host.
# We whitelist: 
# 1. "DevTools listening on" (The URL Flutter needs)
# 2. "Google Chrome" / "Chromium" (Version check)
FILTER_REGEX="DevTools listening on|Google Chrome|Chromium"
CMD="stdbuf -o0 -e0 google-chrome $FLAGS ${ARGS[*]} 2>&1 | stdbuf -o0 grep --line-buffered -E '$FILTER_REGEX' & wait"

CHROME_OUT="/tmp/chrome_out.$$"
touch "$CHROME_OUT"

# Run docker exec
# -i is crucial for Flutter to see the output
docker exec \
  -i \
  -u $(id -u):$(id -g) \
  -e HOME="$CONTAINER_CHROME_HOME" \
  docker-headless-chrome \
  bash -c "$CMD" > "$CHROME_OUT" 2>&1 &

PID=$!

# Tail output to stdout (Simple, no host-side filtering needed now)
stdbuf -o0 tail -f -n +1 "$CHROME_OUT" --pid $PID &
TAIL_PID=$!

# DEBUG: Dump content of CHROME_OUT periodically to see if it's empty
# We write to a separate file so run_integration.sh can cat it later, bypassing flutter's stderr capture
DEBUG_LOG="/tmp/chrome_debug_log"
echo "Starting Chrome Debug Monitor..." > "$DEBUG_LOG"

(
  for i in {1..40}; do
    sleep 2
    if [ -f "$CHROME_OUT" ]; then
        OPSIZE=$(wc -c < "$CHROME_OUT")
        echo "DEBUG $(date +%H:%M:%S): CHROME_OUT size: $OPSIZE bytes" >> "$DEBUG_LOG"
        if [ "$OPSIZE" -gt 0 ]; then
           echo "DEBUG $(date +%H:%M:%S): CHROME_OUT head:" >> "$DEBUG_LOG"
           head -n 5 "$CHROME_OUT" >> "$DEBUG_LOG"
        fi
    else
        echo "DEBUG $(date +%H:%M:%S): CHROME_OUT file not found yet" >> "$DEBUG_LOG"
    fi
  done
) &

wait $PID
EXIT_CODE=$?

# Cleanup
kill $TAIL_PID 2>/dev/null
# rm -f "$CHROME_OUT"

exit $EXIT_CODE
