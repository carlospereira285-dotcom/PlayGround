#!/usr/bin/env bash
set -euo pipefail
time -p cd "$(dirname "$0")"
/usr/bin/time -p pwd
PROJECT_ROOT="$(pwd)"
/usr/bin/time -p mkdir -p "$PROJECT_ROOT/dist"
time -p export PORT="${PORT:-3000}"
/usr/bin/time -p bash -c 'echo "PORT=$PORT"'
/usr/bin/time -p bash -c 'if [ -f package.json ]; then if [ -f package-lock.json ]; then npm ci --no-audit --no-fund; else npm install --no-audit --no-fund; fi; else echo "no package.json, skip install"; fi'
/usr/bin/time -p bash -c 'if [ -f src/index.html ]; then if [ ! -f dist/index.html ] || [ src/index.html -nt dist/index.html ]; then cp -f src/index.html dist/index.html; echo "built dist/index.html from src"; else echo "dist up to date"; fi; else echo "no src to build"; fi'
/usr/bin/time -p test -f "$PROJECT_ROOT/dist/index.html"
/usr/bin/time -p bash -c 'OUT_DIR="${OPENCODE_WEB_DIR:-/home/runner/work/_temp/omgithub-web}"; mkdir -p "$OUT_DIR"; ROOT="$(pwd)"; DIST="$ROOT/dist"; printf "%s" "{\"project\":\"$ROOT\",\"directory\":\"$DIST\"}" > "$OUT_DIR/deployment-output.json"; cat "$OUT_DIR/deployment-output.json"; echo'
/usr/bin/time -p bash -c 'echo "serving $PWD/dist on PORT=${PORT:-3000}"'
exec /usr/bin/time -p node "$PROJECT_ROOT/server.mjs" "$PROJECT_ROOT/dist"
