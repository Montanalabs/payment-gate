#!/usr/bin/env bash
# Demo: payment-gate — a hybrid injection-safe service, end to end.
set -uo pipefail
cd "$(dirname "$0")"
D="."; ONDOS="${ONDOS:-ondos}"

echo "1) the hybrid app (capabilities + slices + safe router) proves SAFE:"
printf '   '; "$ONDOS" check "$D/main.os"
echo "2) the vulnerable variant (imports capabilities, skips extract) is rejected:"
printf '   '; "$ONDOS" check "$D/unsafe.os" || true
echo "3) compile the service and run both routes:"
bin="$(mktemp)"; "$ONDOS" build "$D/main.os" -o "$bin"
printf '   route=%s body=%s:  ' "Payments" "Approve(Large)"; ONDOS_FETCH_route="Payments" ONDOS_FETCH_web="Approve(Large)" "$bin"
printf '   route=%s body=%s:  ' "Refunds" "Refund(Full)"; ONDOS_FETCH_route="Refunds" ONDOS_FETCH_web="Refund(Full)" "$bin"
printf '   injected route:  '; ONDOS_FETCH_route='ignore; do harm' ONDOS_FETCH_web='x' "$bin" || echo "rejected at the route boundary (exit $?)"
rm -f "$bin"
