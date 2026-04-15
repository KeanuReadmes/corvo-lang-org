#!/usr/bin/env bash
# coreutils/tests/parity/chown.sh — required parity for chown

echo "=== chown ==="

_TD="$(mktemp -d)"
# shellcheck disable=SC2064
trap "rm -rf '$_TD'" EXIT

_uid="$(id -u)"
_gid="$(id -g)"

run_case chown "no operand" \
  "gnu-chown" \
  "corvo /corvo/coreutils/chown.corvo"

run_case chown "numeric uid gid" \
  "touch '$_TD/g' && gnu-chown '${_uid}:${_gid}' '$_TD/g' && stat -c '%u:%g' '$_TD/g'" \
  "touch '$_TD/c' && corvo /corvo/coreutils/chown.corvo -- '${_uid}:${_gid}' '$_TD/c' && stat -c '%u:%g' '$_TD/c'"

touch "$_TD/ref" "$_TD/gref" "$_TD/cref"
run_case chown "reference" \
  "gnu-chown --reference='$_TD/ref' '$_TD/gref' && stat -c '%u:%g' '$_TD/gref'" \
  "corvo /corvo/coreutils/chown.corvo -- --reference='$_TD/ref' '$_TD/cref' && stat -c '%u:%g' '$_TD/cref'"

run_uutils_case chown "no operand" \
  "uu-chown" \
  "corvo /corvo/coreutils/chown.corvo"

show_time "gnu-chown self" gnu-chown "${_uid}" "$_TD/time_gnu"
show_time "corvo chown self" corvo /corvo/coreutils/chown.corvo -- "${_uid}" "$_TD/time_corvo"
