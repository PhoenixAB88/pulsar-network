#!/usr/bin/env bash
# Refresh the LIVE public dashboard: pull fresh gossip data, then push to GitHub Pages.
# Usage: bash publish.sh [seed_ip]
set -e
cd "$(dirname "$0")"

bash pull_network.sh "$@"          # writes network_data.js (needs your SSH key)
cp -f Pulsar_Network.html index.html

git add network_data.js index.html Pulsar_Network.html
if git commit -m "refresh network data $(date '+%Y-%m-%d %H:%M')"; then
  git push
  echo "Pushed. Live site refreshes in ~1 minute."
else
  echo "No changes to publish."
fi
