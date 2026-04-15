#!/usr/bin/env bash
# coreutils/tests/matrix/chown.sh

echo "=== matrix chown ==="

_TD="$(mktemp -d)"
trap "rm -rf '$_TD'" EXIT

_uid="$(id -u)"

run_case m-chown "uid only" \
  "touch '$_TD/g' && gnu-chown '${_uid}' '$_TD/g' && stat -c '%u' '$_TD/g'" \
  "touch '$_TD/c' && corvo /corvo/coreutils/chown.corvo -- '${_uid}' '$_TD/c' && stat -c '%u' '$_TD/c'"

run_uutils_case m-chown "no operand" \
  "uu-chown" \
  "corvo /corvo/coreutils/chown.corvo"

show_time "matrix gnu-chown" gnu-chown "${_uid}" "$_TD/mg"
show_time "matrix corvo chown" corvo /corvo/coreutils/chown.corvo -- "${_uid}" "$_TD/mc"
