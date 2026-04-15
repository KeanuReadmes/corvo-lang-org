#!/usr/bin/env bash
# coreutils/tests/matrix/chmod.sh — extended chmod cases

echo "=== matrix chmod ==="

_TD="$(mktemp -d)"
trap "rm -rf '$_TD'" EXIT

run_case m-chmod "a+r" \
  "touch '$_TD/g' && gnu-chmod a+r '$_TD/g' && stat -c '%a' '$_TD/g'" \
  "touch '$_TD/c' && corvo /corvo/coreutils/chmod.corvo -- a+r '$_TD/c' && stat -c '%a' '$_TD/c'"

run_case m-chmod "go-w" \
  "touch '$_TD/g2' && gnu-chmod go-w '$_TD/g2' && stat -c '%a' '$_TD/g2'" \
  "touch '$_TD/c2' && corvo /corvo/coreutils/chmod.corvo -- go-w '$_TD/c2' && stat -c '%a' '$_TD/c2'"

touch "$_TD/uu" "$_TD/uu2"
run_uutils_case m-chmod "a+r" \
  "uu-chmod a+r '$_TD/uu'" \
  "corvo /corvo/coreutils/chmod.corvo -- a+r '$_TD/uu2'"

show_time "matrix gnu-chmod" gnu-chmod 755 "$_TD/mg"
show_time "matrix corvo chmod" corvo /corvo/coreutils/chmod.corvo -- 755 "$_TD/mc"
