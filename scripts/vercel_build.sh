#!/usr/bin/env bash
set -euo pipefail
FLUTTER_DIR="${FLUTTER_DIR:-/tmp/flutter}"
if [[ ! -x "$FLUTTER_DIR/bin/flutter" ]]; then
  rm -rf "$FLUTTER_DIR"
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi
"$FLUTTER_DIR/bin/flutter" config --no-analytics
"$FLUTTER_DIR/bin/flutter" pub get
"$FLUTTER_DIR/bin/flutter" build web --release
