#!/usr/bin/env bash
# coreutils/tests/matrix/chcon.sh

echo "=== matrix chcon ==="

_TD="$(mktemp -d)"
trap "rm -rf '$_TD'" EXIT

_CTX="user_u:object_r:user_tmp_t:s0"

run_case m-chcon "context operand" \
  "touch '$_TD/g' && gnu-chcon '${_CTX}' '$_TD/g'" \
  "touch '$_TD/c' && corvo /corvo/coreutils/chcon.corvo -- '${_CTX}' '$_TD/c'"

run_uutils_case m-chcon "no operand" \
  "uu-chcon" \
  "corvo /corvo/coreutils/chcon.corvo"

show_time "matrix gnu-chcon" gnu-chcon "${_CTX}" "$_TD/mg" || true
show_time "matrix corvo chcon" corvo /corvo/coreutils/chcon.corvo -- "${_CTX}" "$_TD/mc" || true
