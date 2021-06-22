# Package

version       = "0.3.0"
author        = "Sergio Tapia"
description   = "A very low memory-footprint, self hosted API-only torrent search engine. Sonarr + Radarr Compatible"
license       = "MIT"
srcDir        = "src"
bin           = @["torrentinim"]



# Dependencies

requires "nim >= 1.4.6"
requires "nimquery >= 1.2.2"
requires "filesize >= 1.0.0"
requires "prologue >= 0.4.4"