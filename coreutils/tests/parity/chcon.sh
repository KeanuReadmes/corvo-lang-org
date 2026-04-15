#!/usr/bin/env bash
# coreutils/tests/parity/chcon.sh — required parity for chcon (SELinux context)

echo "=== chcon ==="

_TD="$(mktemp -d)"
# shellcheck disable=SC2064
trap "rm -rf '$_TD'" EXIT

_CTX="user_u:object_r:user_tmp_t:s0"

run_case chcon "no operand" \
  "gnu-chcon" \
  "corvo /corvo/coreutils/chcon.corvo"

run_case chcon "set context best-effort" \
  "touch '$_TD/g' && gnu-chcon '${_CTX}' '$_TD/g'" \
  "touch '$_TD/c' && corvo /corvo/coreutils/chcon.corvo -- '${_CTX}' '$_TD/c'"

touch "$_TD/ref" "$_TD/gref" "$_TD/cref"
run_case chcon "reference" \
  "gnu-chcon --reference='$_TD/ref' '$_TD/gref'" \
  "corvo /corvo/coreutils/chcon.corvo -- --reference='$_TD/ref' '$_TD/cref'"

run_uutils_case chcon "no operand" \
  "uu-chcon" \
  "corvo /corvo/coreutils/chcon.corvo"

show_time "gnu-chcon" gnu-chcon "${_CTX}" "$_TD/time_gnu" || true
show_time "corvo chcon" corvo /corvo/coreutils/chcon.corvo -- "${_CTX}" "$_TD/time_corvo" || true
