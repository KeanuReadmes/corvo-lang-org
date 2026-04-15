#!/usr/bin/env bash
# coreutils/tests/matrix/run-all.sh
# Entry point executed inside the Docker container for the extended matrix.
# Sources helpers and each per-tool matrix script in turn.
set -uo pipefail

TESTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=../helpers.sh
. "$TESTS_DIR/helpers.sh"

PASS=0; FAIL=0

printf "%-8s %-50s %s\n" "SECTION" "CASE" "RESULT"
printf "%-8s %-50s %s\n" "--------" "--------------------------------------------------" "--------"

cd /fixtures

# Source all matrix scripts in the directory (excluding this one)
for script in "$TESTS_DIR/matrix"/*.sh; do
    [[ "$(basename "$script")" == "run-all.sh" ]] && continue
    . "$script"
done

echo ""
echo "======================================================"
echo "  coreutils parity matrix:  PASS=$PASS  FAIL=$FAIL"
echo "======================================================"
exit $(( FAIL > 0 ? 1 : 0 ))
