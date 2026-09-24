#!/usr/bin/env bash
set -euo pipefail
FLUTTER_DIR="${FLUTTER_DIR:-/tmp/flutter}"
if [[ ! -x "$FLUTTER_DIR/bin/flutter" ]]; then
  rm -rf "$FLUTTER_DIR"
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi
"$FLUTTER_DIR/bin/flutter" config --no-analytics
"$FLUTTER_DIR/bin/flutter" pub get
# Ensure web icons exist (Flutter template defaults) if missing from repo
if [[ ! -f web/favicon.png ]]; then
  mkdir -p /tmp/flutter_web_scaffold
  "$FLUTTER_DIR/bin/flutter" create --platforms=web --project-name scaffold_web /tmp/flutter_web_scaffold >/dev/null
  mkdir -p web/icons
  cp -n /tmp/flutter_web_scaffold/web/favicon.png web/favicon.png || true
  cp -n /tmp/flutter_web_scaffold/web/icons/* web/icons/ || true
fi
"$FLUTTER_DIR/bin/flutter" build web --release
