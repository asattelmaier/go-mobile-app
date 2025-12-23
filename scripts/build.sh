#!/bin/bash
set -e

# Get script directory and app directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP_DIR="$SCRIPT_DIR/.."

echo "=== Starting Build Process ==="

SKIP_GEN=false

for arg in "$@"
do
    case $arg in
        --skip-gen)
        SKIP_GEN=true
        shift # Remove --skip-gen from processing
        ;;
        *)
        shift # Remove generic argument from processing
        ;;
    esac
done

# 1. Generate Client
if [ "$SKIP_GEN" = true ]; then
    echo "Step 1: Skipping Client Generation (--skip-gen)"
else
    echo "Step 1: Generating Client..."
    "$SCRIPT_DIR/generate_client.sh"
fi

# 2. Install Dependencies
echo "Step 2: Installing Dependencies..."
cd "$APP_DIR"
flutter pub get

# 3. Code Generation (build_runner)
echo "Step 3: Running build_runner..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "=== Build Setup Complete ==="
