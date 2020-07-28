# Torrentinim

Torrentinim is a self-hosted API-only, low memory footprint, torrent search engine and crawler.

Native support for Linux, Mac and Windows. [You can find a release for your platform in our releases](https://github.com/sergiotapia/torrentinim/releases).


### Goals

- **API-only**
- Native support for: Linux, Mac and Windows.
- Crawl multiple index sites for torrents and magnet links.
- **[TODO]** Easily integrates with both [Sonarr](https://github.com/Sonarr/Sonarr) and [Radarr](https://github.com/Radarr/Radarr).
- Run without ceremony. You download a binary, run it, that's it.
- Easy to understand source code. Special care is taken to keep code lean and understandable. No code golf here.
- High performance, extremely low memory footprint.
  - RAM usage (avg.): **21.5MB**
  - Binary application size: **1.2MB**

We work closely with other providers and search engines to be respectful of their
hardware and minimize our impact to their systems. Want torrentinim to support your
site? Please open a Github Issue in this repo.

### Usage Guide

Torrentinim was designed to be painless to run. You download an executable, and run it. Done.
It will start slurping up data from supported sources automatically.

The `nuke_my_database` flag initializes the database. All subsequent runs should not 
include `nuke_my_database` or you will nuke your entire database.

```
$ ./torrentinim nuke_my_database
INFO Jester is making jokes at http://0.0.0.0:5000
Starting 1 threads
```

Subsequent runs, don't use the `nuke_my_database` flag!

```
$ ./torrentinim
INFO Jester is making jokes at http://0.0.0.0:50123
Starting 1 threads
```

You can specify the port using the `TORRENTINIM_PORT` environment variable.

```
TORRENTINIM_PORT=60000 ./torrentinim
```

### Community

Want to talk about Torrentinim or suggest features? We have an official Discord server.

[Click to join our official Discord server](https://discord.gg/CFtGUaW)

### Development

You need at least Nim 1.2.0

1. Clone the project
2. `nimble install`
3. `nimble run torrentinim`

To compile release:

>nim c -d:danger -d:ssl --threads:on -d:release --opt:size src/torrentinim.nim

### Supported websites

The following websites are fully supported.

- 1337x.to
- EZTV
- Nyaa
- NyaaPantsu
- NyaaSukebei
- TorrentDownloads.me
- YTS