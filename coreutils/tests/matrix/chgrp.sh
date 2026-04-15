#!/usr/bin/env bash
# coreutils/tests/matrix/chgrp.sh

echo "=== matrix chgrp ==="

_TD="$(mktemp -d)"
trap "rm -rf '$_TD'" EXIT

_g="$(id -gn)"

run_case m-chgrp "group name" \
  "touch '$_TD/g' && gnu-chgrp '${_g}' '$_TD/g' && stat -c '%g' '$_TD/g'" \
  "touch '$_TD/c' && corvo /corvo/coreutils/chgrp.corvo -- '${_g}' '$_TD/c' && stat -c '%g' '$_TD/c'"

run_uutils_case m-chgrp "no operand" \
  "uu-chgrp" \
  "corvo /corvo/coreutils/chgrp.corvo"

show_time "matrix gnu-chgrp" gnu-chgrp "${_g}" "$_TD/mg"
show_time "matrix corvo chgrp" corvo /corvo/coreutils/chgrp.corvo -- "${_g}" "$_TD/mc"
