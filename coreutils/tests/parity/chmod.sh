#!/usr/bin/env bash
# coreutils/tests/parity/chmod.sh — required parity for chmod
# Sourced by parity/run-all.sh

echo "=== chmod ==="

_TD="$(mktemp -d)"
# shellcheck disable=SC2064
trap "rm -rf '$_TD'" EXIT

run_case chmod "no operand" \
  "gnu-chmod" \
  "corvo /corvo/coreutils/chmod.corvo"

run_case chmod "octal 640" \
  "touch '$_TD/g' && gnu-chmod 640 '$_TD/g' && stat -c '%a' '$_TD/g'" \
  "touch '$_TD/c' && corvo /corvo/coreutils/chmod.corvo -- 640 '$_TD/c' && stat -c '%a' '$_TD/c'"

run_case chmod "symbolic u+x" \
  "touch '$_TD/g' && gnu-chmod u+x '$_TD/g' && stat -c '%a' '$_TD/g'" \
  "touch '$_TD/c' && corvo /corvo/coreutils/chmod.corvo -- u+x '$_TD/c' && stat -c '%a' '$_TD/c'"

touch "$_TD/ref" "$_TD/gref" "$_TD/cref"
gnu-chmod 620 "$_TD/ref"
run_case chmod "reference mode" \
  "gnu-chmod --reference='$_TD/ref' '$_TD/gref' && stat -c '%a' '$_TD/gref'" \
  "corvo /corvo/coreutils/chmod.corvo -- --reference='$_TD/ref' '$_TD/cref' && stat -c '%a' '$_TD/cref'"

mkdir -p "$_TD/gd/a" "$_TD/cd/a"
touch "$_TD/gd/a/f" "$_TD/cd/a/f"
gnu-chmod 700 "$_TD/gd"
_gnu_r_ec=0
_corvo_r_ec=0
gnu-chmod -R go+rX "$_TD/gd" >/dev/null 2>&1 || _gnu_r_ec=$?
corvo /corvo/coreutils/chmod.corvo -- -R go+rX "$_TD/cd" >/dev/null 2>&1 || _corvo_r_ec=$?
_gm="$(stat -c '%a' "$_TD/gd/a/f")"
_cm="$(stat -c '%a' "$_TD/cd/a/f")"
if [[ "$_gnu_r_ec" == "$_corvo_r_ec" ]] && [[ "$_gm" == "$_cm" ]]; then
  printf "PASS [chmod] recursive go+rX on tree\n"
  PASS=$((PASS + 1))
else
  printf "FAIL [chmod] recursive go+rX  exit gnu=%s corvo=%s mode gnu=%s corvo=%s\n" \
    "$_gnu_r_ec" "$_corvo_r_ec" "$_gm" "$_cm"
  FAIL=$((FAIL + 1))
fi

run_uutils_case chmod "no operand" \
  "uu-chmod" \
  "corvo /corvo/coreutils/chmod.corvo"

show_time "gnu-chmod file" gnu-chmod 755 "$_TD/time_gnu"
show_time "corvo chmod file" corvo /corvo/coreutils/chmod.corvo -- 755 "$_TD/time_corvo"
