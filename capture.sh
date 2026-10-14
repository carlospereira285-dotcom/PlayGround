#!/usr/bin/env bash
set -euo pipefail
time -p cd "$(dirname "$0")"
/usr/bin/time -p bash -c 'echo "capture start: URL=${CAPTURE_URL:-<unset>} DIR=${CAPTURE_DIR:-<unset>}"'
/usr/bin/time -p bash -c 'if [ -z "${CAPTURE_URL:-}" ]; then echo "CAPTURE_URL is required" >&2; exit 1; fi; if [ -z "${CAPTURE_DIR:-}" ]; then echo "CAPTURE_DIR is required" >&2; exit 1; fi; echo "env OK"'
/usr/bin/time -p mkdir -p "${CAPTURE_DIR:?}"
/usr/bin/time -p bash -c 'echo "RUNTIME_DIR=${RUNTIME_DIR:?}"; test -f "${RUNTIME_DIR:?}/scripts/default-capture.mjs" && echo "capture runtime OK"'
/usr/bin/time -p node "${RUNTIME_DIR:?}/scripts/default-capture.mjs"
STATUS=$?
/usr/bin/time -p bash -c 'echo "capture exit=$STATUS"; ls -la "${CAPTURE_DIR:?}" || true'
exit $STATUS
