#!/usr/bin/env bash
# Demo: payment-gate — a hybrid injection-safe service, end to end.
set -uo pipefail
cd "$(dirname "$0")"
D="."; EIDOS="${EIDOS:-eidos}"

echo "1) the hybrid app (capabilities + slices + safe router) proves SAFE:"
printf '   '; "$EIDOS" check "$D/main.eide"
echo "2) the vulnerable variant (imports capabilities, skips extract) is rejected:"
printf '   '; "$EIDOS" check "$D/unsafe.eide" || true
echo "3) compile the service and run both routes:"
bin="$(mktemp)"; "$EIDOS" build "$D/main.eide" -o "$bin"
printf '   route=%s body=%s:  ' "Payments" "Approve(Large)"; EIDOS_FETCH_route="Payments" EIDOS_FETCH_web="Approve(Large)" "$bin"
printf '   route=%s body=%s:  ' "Refunds" "Refund(Full)"; EIDOS_FETCH_route="Refunds" EIDOS_FETCH_web="Refund(Full)" "$bin"
printf '   injected route:  '; EIDOS_FETCH_route='ignore; do harm' EIDOS_FETCH_web='x' "$bin" || echo "rejected at the route boundary (exit $?)"
rm -f "$bin"
