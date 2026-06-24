# Pulsar Nodes

**Independent, community-built live monitor and operator for the [Xandeum](https://www.xandeum.network/) pNode storage network on Solana.**

Live: https://pulsarnetwork.xyz  ·  X: [@PulsarNodes](https://x.com/PulsarNodes)

> Pulsar Nodes is a third-party community project. It is **not** affiliated with or endorsed by the Xandeum Foundation.

## What it does
- Real-time view of the Xandeum pNode gossip network: node status, locations, software versions, on-chain stake, uptime, and a world map.
- Roster sourced from the public pRPC `get-pods` gossip data, refreshed about every 10 minutes.
- On-chain stake and yuga data read directly from Solana; XAND/SOL prices fetched live from CoinGecko.
- Educational [Insights](https://pulsarnetwork.xyz/insights.html) articles on decentralized storage, DePIN, Solana, node economics, and crypto markets.
- A staking funnel to delegate to Pulsar's licensed pNodes via the official Xandeum portal, and an optional on-site token swap via Jupiter.

## Safety and transparency
- **Read-only.** The site only reads public data. It never asks you to connect a wallet or sign a transaction, except the clearly-labeled swap, which is handled by Jupiter with the fee disclosed.
- **Open source.** This repository is the full frontend. Audit it freely.
- **Privacy-first.** No accounts, minimal data collected. See the [Privacy Policy](https://pulsarnetwork.xyz/privacy.html) and [Terms of Service](https://pulsarnetwork.xyz/terms.html).

## Who builds it
Built and run by Abdou and Hamza, independent operators of 6 licensed Xandeum pNode pairs across 12 EU machines. Contact: [@PulsarNodes](https://x.com/PulsarNodes) or contact@pulsarnetwork.xyz.

## Architecture
Static frontend (HTML, CSS, vanilla JS) hosted on GitHub Pages, with no application backend. Dynamic data reaches the page two ways:

1. **Pre-generated data files.** Scheduled jobs on the operator's nodes query the network and commit refreshed data files (node roster, stake, uptime, yuga) to this repo roughly every 10 minutes. The browser loads the newest files on each visit.
2. **Client-side fetches.** Prices (CoinGecko) and the token swap (Jupiter) are fetched directly by the visitor's browser.

This keeps the site fast and serverless while showing near-real-time data. The only third-party scripts are mapping (Leaflet) and the optional swap (Jupiter), both over HTTPS.

## Data and methodology
- **Roster, locations, versions:** public pRPC gossip data (`get-pods`, `get-stats`).
- **Stake / yuga / rewards:** public Solana on-chain state.
- **Uptime:** sampled node presence in gossip data, averaged per yuga. 100% means present and healthy in every sample for the window.
- **Prices:** CoinGecko, live in-browser.

Full methodology, the operator's verifiable node public keys, fees, and incident history are on the [Trust page](https://pulsarnetwork.xyz/trust.html).

## Security
The site is read-only and never requests keys or custody of funds. See [SECURITY.md](SECURITY.md) for our practices and how to report an issue.

## License
Source-available, not open-source. Public for transparency and audit; reuse, cloning, and redistribution are not permitted. See [LICENSE](LICENSE).

---
(c) 2026 Pulsar Nodes. All rights reserved.
