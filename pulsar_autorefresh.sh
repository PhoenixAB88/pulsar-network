#!/usr/bin/env bash
# Pulsar Network DEVNET auto-refresh — runs ON a devnet node via cron.
# get-pods (localhost pRPC) -> geolocate via pulsar_build.py -> push to GitHub Pages repo.
set -e
REPO=/root/pulsar-network
cd "$REPO"

git pull -q --rebase origin main || true

curl -s -X POST http://127.0.0.1:6000/rpc -H 'content-type: application/json' \
  -d '{"jsonrpc":"2.0","method":"get-pods","id":1}' > /tmp/pods_dev.json
grep -q '"pods"' /tmp/pods_dev.json || { echo "$(date -u) ERROR: no pods"; exit 1; }

python3 /root/pulsar_build.py /tmp/pods_dev.json network_data.js NETWORK

git add network_data.js
git -c user.name='Pulsar Bot' -c user.email='bot@users.noreply.github.com' \
    commit -q -m "auto: refresh devnet $(date -u '+%Y-%m-%d %H:%M')" || { echo "$(date -u) no change"; exit 0; }
git push -q origin main
echo "$(date -u) pushed devnet"
