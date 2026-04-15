#!/usr/bin/env bash
# coreutils/tests/parity/run-all.sh
# Entry point executed inside the Docker container for required parity tests.
# Sources helpers and each per-tool parity script in turn.
set -uo pipefail

TESTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=../helpers.sh
. "$TESTS_DIR/helpers.sh"

PASS=0; FAIL=0

cd /fixtures

# Pre-compile tools for transpilation testing (compiled vs interpreted parity)
for f in /corvo/coreutils/*.corvo; do
    prepare_compiled "$f" || true
done

# Source all parity scripts in the directory (excluding this one)
for script in "$TESTS_DIR/parity"/*.sh; do
    [[ "$(basename "$script")" == "run-all.sh" ]] && continue
    . "$script"
done

echo ""
echo "=================================================="
echo "  coreutils parity:  PASS=$PASS  FAIL=$FAIL"
echo "=================================================="
exit $(( FAIL > 0 ? 1 : 0 ))
