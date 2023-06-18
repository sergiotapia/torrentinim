# Package

version       = "0.8.0"
author        = "Sergio Tapia"
description   = "A very low memory-footprint, self hosted API-only torrent search engine. Sonarr + Radarr Compatible"
license       = "MIT"
srcDir        = "src"
bin           = @["torrentinim"]



# Dependencies

requires "nim >= 1.6.12"
requires "nimquery >= 1.2.3"
requires "filesize >= 1.0.0"
requires "prologue >= 0.5.6"