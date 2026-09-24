#!/usr/bin/env bash
set -euo pipefail
FLUTTER_DIR="${FLUTTER_DIR:-/tmp/flutter}"
if [[ ! -x "$FLUTTER_DIR/bin/flutter" ]]; then
  rm -rf "$FLUTTER_DIR"
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi
"$FLUTTER_DIR/bin/flutter" config --no-analytics

# Side-repo may omit binary icons; copy defaults from Flutter SDK examples.
ICON_SRC="$FLUTTER_DIR/examples/api/web"
if [[ -d "$ICON_SRC" ]]; then
  mkdir -p web/icons
  for f in favicon.png icons/Icon-192.png icons/Icon-512.png icons/Icon-maskable-192.png icons/Icon-maskable-512.png; do
    if [[ ! -f "web/$f" && -f "$ICON_SRC/$f" ]]; then
      cp "$ICON_SRC/$f" "web/$f"
    fi
  done
fi

"$FLUTTER_DIR/bin/flutter" pub get
"$FLUTTER_DIR/bin/flutter" build web --release
