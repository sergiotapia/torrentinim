![image](https://user-images.githubusercontent.com/686715/93164356-53add180-f6e7-11ea-83ab-6cff289dab7e.png)

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
  - Binary application size: **600KB**

We work closely with other providers and search engines to be respectful of their
hardware and minimize our impact to their systems. Want torrentinim to support your
site? Please open a Github Issue in this repo.

### Usage Guide

Torrentinim was designed to be painless to run. You download an executable, and run it. Done.
It will start slurping up data from supported sources automatically.

The `NUKE_MY_DATABASE` environment variable initializes the database. All subsequent runs should not 
include `NUKE_MY_DATABASE` or you will nuke your entire database.

```
$ NUKE_MY_DATABASE=true ./torrentinim
[system] Database nuke requested. Clearing all database tables and data.
[system] Initializing database
Torrentinim is running, bambino. http://localhost:50123
```

Subsequent runs, don't use the `NUKE_MY_DATABASE` flag!

```
$ ./torrentinim
Torrentinim is running, bambino. http://localhost:50123
```

Environment variables:

- `TORRENTINIM_PORT` - what port the app will run on.
- `ALLOW_ORIGINS` - CORS allowed origins.

Example:

```
TORRENTINIM_PORT=60000 ALLOW_ORIGINS="https://example.com" ./torrentinim
```

Use the search JSON endpoint to perform searches against all the scraped torrents
you have saved locally.

```
http://localhost:50123/search?query=the other guys&page=1
```

### Community

Want to talk about Torrentinim or suggest features? We have an official Discord server.

[Click to join our official Discord server](https://discord.gg/CFtGUaW)

### Development

You need at least Nim 1.2.0

1. Clone the project
2. `asdf install` (to install the version of Nim in .tool-versions)
3. `make deps`
4. `make run`

To compile release:

1. `make build`

### Github Release

1. Update `torrentinim.nimble` package version with the tag version.

```
version       = "0.4.0"
git tag v0.4.0
```

2. Push up your tags

```
git push origin --tags
```

### Supported websites

The following websites are fully supported.

- eztv
- 1337x
- nyaa pantsu
- nyaa
- rarbg
- thepiratebay
- torrentdownloads.me
- yts

### Thank you's:

- @chhdamian for the Torrentinim logo
