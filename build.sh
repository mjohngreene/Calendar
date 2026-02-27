#!/bin/bash
#
# build.sh — Merge Calendar app code + dependencies into a complete Urbit desk
#
# Layering order (later layers override earlier):
#   1. base-dev (system marks, libs, sur)
#   2. landscape-dev (docket mark/lib/sur)
#   3. App code (Calendar-specific files)
#
# Usage:
#   ./build.sh          # builds into ./dist/calendar/
#   ./build.sh clean    # removes dist/
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DIST_DIR="$SCRIPT_DIR/dist/calendar"

if [ "${1:-}" = "clean" ]; then
    echo "Cleaning dist/..."
    rm -rf "$SCRIPT_DIR/dist"
    echo "Done."
    exit 0
fi

echo "Building Calendar desk..."
echo "========================="

# Start fresh
rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

# Layer 1: base-dev (system dependencies)
echo "[1/3] Copying base-dev dependencies..."
if [ -d "$SCRIPT_DIR/deps/base-dev" ]; then
    cp -R "$SCRIPT_DIR/deps/base-dev"/* "$DIST_DIR/"
else
    echo "ERROR: deps/base-dev/ not found. Run setup first."
    exit 1
fi

# Layer 2: landscape-dev (docket/Landscape dependencies)
echo "[2/3] Copying landscape-dev dependencies..."
if [ -d "$SCRIPT_DIR/deps/landscape-dev" ]; then
    cp -R "$SCRIPT_DIR/deps/landscape-dev"/* "$DIST_DIR/"
else
    echo "WARNING: deps/landscape-dev/ not found. Docket mark may be missing."
fi

# Layer 3: App code (overrides any dep files with same name)
echo "[3/3] Copying Calendar app code..."
for item in app gen lib mar sur sys.kelvin desk.bill desk.docket-0; do
    if [ -e "$SCRIPT_DIR/$item" ]; then
        cp -R "$SCRIPT_DIR/$item" "$DIST_DIR/"
    fi
done

# Verify required files
echo ""
echo "Verifying desk contents..."
MISSING=0
REQUIRED_FILES=(
    "sys.kelvin"
    "desk.bill"
    "desk.docket-0"
    "app/calendar.hoon"
    "sur/calendar.hoon"
    "lib/calendar.hoon"
    "lib/calendar-date.hoon"
    "lib/calendar-ui.hoon"
    "lib/server.hoon"
    "lib/default-agent.hoon"
    "lib/dbug.hoon"
    "mar/hoon.hoon"
    "mar/kelvin.hoon"
    "mar/noun.hoon"
    "mar/txt.hoon"
    "mar/json.hoon"
    "mar/mime.hoon"
    "mar/docket-0.hoon"
    "mar/calendar/action.hoon"
    "mar/calendar/update.hoon"
    "gen/calendar/add.hoon"
    "gen/calendar/list.hoon"
    "gen/calendar/delete.hoon"
    "gen/test-calendar.hoon"
    "gen/test-calendar-date.hoon"
)

for f in "${REQUIRED_FILES[@]}"; do
    if [ -f "$DIST_DIR/$f" ]; then
        echo "  ✓ $f"
    else
        echo "  ✗ MISSING: $f"
        MISSING=$((MISSING + 1))
    fi
done

echo ""
TOTAL=$(find "$DIST_DIR" -type f | wc -l | tr -d ' ')
echo "Total files in desk: $TOTAL"

if [ "$MISSING" -gt 0 ]; then
    echo ""
    echo "WARNING: $MISSING required file(s) missing!"
    exit 1
else
    echo ""
    echo "✅ Build complete: $DIST_DIR"
    echo ""
    echo "To install on a fakezod:"
    echo "  1. Copy dist/calendar/ to your pier's desk mount point"
    echo "  2. In dojo: |merge %calendar our %base"
    echo "  3. Copy files: cp -r dist/calendar/* /path/to/zod/calendar/"
    echo "  4. In dojo: |commit %calendar"
    echo "  5. In dojo: |install our %calendar"
fi
