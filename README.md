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

On average the application **(1MB size)** uses about **6MB of RAM**:

<img width="212" alt="Screen Shot 2020-05-17 at 11 47 03 PM" src="https://user-images.githubusercontent.com/686715/82172638-bf4a7400-9898-11ea-809d-02bb2a0c00d3.png">

<img width="278" alt="Screen Shot 2020-05-17 at 11 45 37 PM" src="https://user-images.githubusercontent.com/686715/82172601-a6da5980-9898-11ea-92a3-6be4087d93cb.png">

We work closely with other providers and search engines to be respectful of their
hardware and minimize our impact to their systems. Want torrentinim to support your
site? Please open a Github Issue in this repo.

### Usage Guide

Torrentinim was designed to be painless to run. You download an executable, and run it. Done.
It will start slurping up data from supported sources automatically.

The `init` flag initializes the database. All subsequent runs should not include `init` or you
will nuke your entire database.

```
$ ./torrentinim init
INFO Jester is making jokes at http://0.0.0.0:5000
Starting 1 threads
```

Subsequent runs, don't use the `init` flag!

```
$ ./torrentinim
INFO Jester is making jokes at http://0.0.0.0:5000
Starting 1 threads
```

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
- Nyaa
- NyaaPantsu
- TorrentDownloads.me
- YTS