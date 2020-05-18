# Torrentinim

Torrentinim is a self-hosted API-only, low memory footprint, torrent search engine.

_This is a work in progress as I learn Nim, and build out more features. Once I complete
the initial set of working features, I'll remove this notice and add screenshots._

# TODO: Take screenshots of some results.

### Goals

- **API-only**
- Crawl multiple index sites for torrents and magnet links.
- Easily integrates with both [Sonarr](https://github.com/Sonarr/Sonarr) and [Radarr](https://github.com/Radarr/Radarr).
- Run without ceremony. You download a binary, run it, that's it.
- Easy to understand source code. Special care is taken to keep code lean and understandable. No code golf here.
- High performance, extremely low memory footprint.

On average the application (1MB size) uses about 6MB of RAM:

# TODO: Take screenshot of the application's memory usage after 24 hours being up and running.

We work closely with other providers and search engines to be respectful of their hardware and minimize our impact to their systems.

If you'd like us to add you to our supported vendors list, please drop us a Github Issue.

### Usage Guide

Torrentinim was designed to be painless to run. You download an executable, and run it. Done.

# TODO: Link to platform releases here. Mac, Windows and Linux.

### Community

Want to talk about Torrentinim or suggest features? We have an official Discord server.

[Click to join our official Discord server](https://discord.gg/CFtGUaW)

### Development

You need at least Nim 1.2.0

1. Clone the project
2. `nimble install`
3. `nimble run torrentinim`

### Supported websites

The following websites are fully supported.

- 1337x.to
- EZTV