#!/usr/bin/env bash
# Pulsar Network (public v2) — data generator.
# Run on your Mac:  bash pull_network.sh [seed_ip]
# SSHes one of YOUR nodes and asks its localhost pRPC for the whole gossip roster
# (get_pods). No port is exposed publicly; the node queries itself on 127.0.0.1:6000.
# Writes network_data.js next to Pulsar_Network.html.
set -u
cd "$(dirname "$0")"
KEY=~/.ssh/xandeum
SEED="${1:-62.171.187.91}"   # a DEVNET node (pRPC/Herrenberg lives on 1.4.2 devnet pods)
OUT=network_data.js

echo "Querying gossip roster via $SEED (localhost pRPC) ..." 1>&2
RAW=$(ssh -i "$KEY" -o ConnectTimeout=10 -o BatchMode=yes -o StrictHostKeyChecking=accept-new root@"$SEED" \
  'curl -s -X POST http://127.0.0.1:6000/rpc -H "content-type: application/json" -d "{\"jsonrpc\":\"2.0\",\"method\":\"get-pods\",\"id\":1}"' 2>/dev/null)

if [ -z "$RAW" ] || ! echo "$RAW" | grep -q '"pods"'; then
  echo "FAILED: no pod list from $SEED:6000." 1>&2
  echo "  - Check the node is up and the pod/pRPC service is running (port 6000)." 1>&2
  echo "  - Try another seed: bash pull_network.sh 13.140.143.121" 1>&2
  exit 1
fi

{
  echo "// generated $(date '+%Y-%m-%d %H:%M %Z') — seed $SEED — method get-pods"
  echo "window.NETWORK_UPDATED = \"$(date '+%Y-%m-%d %H:%M')\";"
  echo "window.NETWORK_GENERATED_TS = $(date +%s);"
  echo -n "window.NETWORK = "
  printf '%s' "$RAW"
  echo ";"
} > "$OUT"

COUNT=$(printf '%s' "$RAW" | grep -o '"address"' | wc -l | tr -d ' ')
echo "Wrote $OUT  ($COUNT pNodes in gossip). Reload Pulsar_Network.html." 1>&2
