#!/usr/bin/env bash
# coreutils/tests/parity/chgrp.sh — required parity for chgrp

echo "=== chgrp ==="

_TD="$(mktemp -d)"
# shellcheck disable=SC2064
trap "rm -rf '$_TD'" EXIT

_g="$(id -gn)"
_gid="$(id -g)"

run_case chgrp "no operand" \
  "gnu-chgrp" \
  "corvo /corvo/coreutils/chgrp.corvo"

run_case chgrp "to invoking group" \
  "touch '$_TD/g' && gnu-chgrp '${_g}' '$_TD/g' && stat -c '%g' '$_TD/g'" \
  "touch '$_TD/c' && corvo /corvo/coreutils/chgrp.corvo -- '${_g}' '$_TD/c' && stat -c '%g' '$_TD/c'"

run_case chgrp "numeric gid" \
  "touch '$_TD/g2' && gnu-chgrp '${_gid}' '$_TD/g2' && stat -c '%g' '$_TD/g2'" \
  "touch '$_TD/c2' && corvo /corvo/coreutils/chgrp.corvo -- '${_gid}' '$_TD/c2' && stat -c '%g' '$_TD/c2'"

run_uutils_case chgrp "no operand" \
  "uu-chgrp" \
  "corvo /corvo/coreutils/chgrp.corvo"

show_time "gnu-chgrp" gnu-chgrp "${_g}" "$_TD/time_gnu"
show_time "corvo chgrp" corvo /corvo/coreutils/chgrp.corvo -- "${_g}" "$_TD/time_corvo"
