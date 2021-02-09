import os
import json
import prologue
import strutils

import "database"
import "./helpers/datetime"
import "./torrents"
from "./crawlers/eztv" import nil
from "./crawlers/leetx.nim" import nil
from "./crawlers/nyaa.nim" import nil
from "./crawlers/nyaa_pantsu.nim" import nil
from "./crawlers/yts.nim" import nil
from "./crawlers/torrent_downloads.nim" import nil
from "./crawlers/nyaa_sukebei.nim" import nil
from "./crawlers/thepiratebay.nim" import nil
from "./crawlers/rarbg.nim" import nil

when isMainModule:
  if (initRequested()):
    discard initDatabase()

  asyncCheck eztv.startCrawl()
  asyncCheck leetx.startCrawl()
  asyncCheck nyaa.startCrawl()
  asyncCheck nyaa_pantsu.startCrawl()
  asyncCheck nyaa_sukebei.startCrawl()
  asyncCheck yts.startCrawl()
  asyncCheck torrentdownloads.startCrawl()
  asyncCheck thepiratebay.startCrawl()
  asyncCheck rarbg.startCrawl()

  let settings = newSettings(debug = false, port = Port(getEnv("TORRENTINIM_PORT", "50123").parseInt()))
  var app = newApp(settings = settings)

  proc hello*(ctx: Context) {.async.} =
    resp "Torrentinim is running, bambino."

  proc search*(ctx: Context) {.async.} =
    let query = ctx.getQueryParams("query")
    let page = ctx.getQueryParams("page")
    let results = searchTorrents(query, page)
    resp jsonResponse(%results)
  
  app.addRoute("/", hello)
  app.addRoute("/search", search)
  app.run()

  # runForever()
