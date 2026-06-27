# Security Policy

## Reporting a vulnerability
If you discover a security issue in pulsarnetwork.xyz or this repository, please report it privately:

- Email: contact@pulsarnetwork.xyz
- Subject line: "Security report - Pulsar Network"

Include steps to reproduce and any relevant details. We aim to acknowledge reports within 72 hours. Please do not publicly disclose an issue until we have had a reasonable opportunity to address it.

## Scope
- The static frontend in this repository.
- The live site at https://pulsarnetwork.xyz.

Out of scope: third-party services we link to or embed (Jupiter, the official Xandeum staking portal, CoinGecko, map-tile providers). These have their own security programs.

## Our practices
- **Read-only frontend.** The site never requests private keys, seed phrases, or custody of funds. The only signing path is the clearly-labeled token swap, executed by Jupiter from the user's own self-custodied wallet.
- **No secrets in client code.** API keys for privileged data sources stay server-side and are never committed to this repository.
- **Hardened infrastructure.** Operator nodes use key-only SSH, a restrictive inbound firewall allow-list, and least-privilege access.
- **HTTPS everywhere.** All assets, including CDN dependencies, load over HTTPS.
- **Limited dependencies.** The frontend uses a small, pinned set of well-known libraries (e.g., Leaflet for mapping).

## Supported version
The version currently deployed on the `main` branch is the supported version.
